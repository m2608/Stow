(local
  {: assoc
   : merge 
   : first 
   : second
   : map 
   : filter 
   : reduce
   : keys
   : kv-pairs 
   : empty? 
   : nil?
   } (require "nfnl.core"))
(local str  (require "nfnl.string"))

(local parsers {
  :clojure         {:repo "sogaiu/tree-sitter-clojure"}
  :cpp             {:repo "tree-sitter/tree-sitter-cpp"}
  :fennel          {:repo "alexmozaidze/tree-sitter-fennel"}
  :html            {:repo "tree-sitter/tree-sitter-html"}
  :hurl            {:repo "pfeiferj/tree-sitter-hurl"}
  :janet_simple    {:repo "sogaiu/tree-sitter-janet-simple"}
  ; :js              {:repo "tree-sitter/tree-sitter-javascript"}
  :jq              {:repo "flurie/tree-sitter-jq"}
  :json            {:repo "tree-sitter/tree-sitter-json"}
  :make            {:repo "tree-sitter-grammars/tree-sitter-make"}
  ; :markdown        {:repo "tree-sitter-grammars/tree-sitter-markdown"}
  ; :markdown_inline {:repo "tree-sitter-grammars/tree-sitter-markdown"}
  :python          {:repo "tree-sitter/tree-sitter-python"}
  :scheme          {:repo "6cdh/tree-sitter-scheme"}
  ; :sql             {:repo "derekstride/tree-sitter-sql"}
  ; :xml             {:repo "tree-sitter-grammars/tree-sitter-xml" :cmd "make -C xml"}
  :yaml            {:repo "tree-sitter-grammars/tree-sitter-yaml"}
})

(local queries {:repo "nvim-treesitter/nvim-treesitter"
                :subfolder "runtime/queries"})

(local tsitter-path (vim.fs.joinpath (os.getenv "HOME") ".local/share/nvim/treesitter"))

(fn ok [val]
  {:status :ok :val val})

(fn err [...]
  {:status :err :msg (str.join [...])})

(fn bind [result f]
  (if (= result.status :ok)
      (f result.val)
      result))

(fn log [result ...]
  "Выводит сообщение и возвращает первый аргумент."
  (when (= result.status :ok)
    (print (str.join [...])))
  result)

(fn run [cmd opts]
  (let [p (vim.system cmd (merge {:text true} opts))]
    (p:wait)))

(fn check-requirements [rs]
  (let [fails (filter (fn [r] (= 0 (vim.fn.executable r))) rs)]
    (if (empty? fails)
        (ok rs)
        (err "Requirements not satisfied: " (str.join ", " fails) "."))))

(fn create-dir
  [path]
  "Создаёт указанный каталог. В случае успеха возвращает путь к нему."
  (let [r (run ["mkdir" "-p" path])]
    (if (= 0 r.code)
        (ok path)
        (err "Could not create folder: " path))))

(fn create-temp-dir [path]
  "Создаёт временный каталог. В случае успеха возвращает путь к нему."
  (let [r (run ["mktemp" "-d"])]
    (when (= 0 r.code)
      (first (str.split r.stdout "\n")))))

(fn remove-dir [path]
  "Удаляет каталог."
  (if (vim.uv.fs_stat path)
      (let [(_ e) (vim.fs.rm path {:recursive true})]
        (if (not e)
            (ok path)
            (err "Could not remove folder: " path)))
      (ok path)))

(fn copy-dir [src dst]
  "Рекурсивно копирует каталог."
  (print "Copying" src "to" dst)
  (let [r (run ["cp" "-r" src dst])]
    (if (= 0 r.code)
      (ok dst)
      (err "Could not copy folder " src " to " dst))))

(fn clone-repo [repo path]
  "Клонирует репозиторий с github в указанный каталог."
  (let [r (run ["git" "clone" "--depth=1" (.. "https://github.com/" repo) path])]
    (if (= 0 r.code)
        (ok path)
        (err "Could not clone repository: " repo))))

(fn build-parser [path]
  (let [r (run ["tree-sitter" "build"] {:cwd path})]
    (if (= 0 r.code)
        (ok path)
        (err "Could not build parser at " path))))

(fn find-parser-lib
  [path]
  (let [lib (first
              (vim.fn.readdir path (fn [s] (str.ends-with? s ".so"))))]
    (if lib
        (ok (vim.fs.joinpath path lib))
        (err "Could not find parser library at " path))))

(fn copy-parser-lib [lib-path dst]
  (let [(_ e) (vim.uv.fs_copyfile lib-path dst)]
    (if (not e)
        (ok dst)
        (err "Could not copy " lib-path " into " dst "."))))

(fn add-parser [parsers-path parser repo force-rebuild]
  (let [dst (vim.fs.joinpath parsers-path (.. parser ".so"))]
    (if (and (not force-rebuild) (vim.uv.fs_stat dst))
        (ok dst)
        (let [temp-dir (create-temp-dir)]
          (if temp-dir
              (let [result (-> {:status :ok}
                               (log "Cloning repo " repo "...")
                               (bind (fn [_] (clone-repo repo temp-dir)))
                               (log "Building parser " parser "...")
                               (bind (fn [_] (build-parser temp-dir)))
                               (bind (fn [_] (find-parser-lib temp-dir)))
                               (bind (fn [lib] (copy-parser-lib lib dst)))
                               (log "Parser copied to " dst))]
                (remove-dir temp-dir)
                result)
              (err "Could not create temporary folder."))))))

(fn add-queries [tsitter-path queries force-rebuild]
  (let [queries-path (vim.fs.joinpath tsitter-path "queries")]
    (if (and (not force-rebuild) (vim.uv.fs_stat queries-path))
        (ok queries-path)
        (let [temp-dir (create-temp-dir)
              repo (. queries :repo)]
          (if temp-dir
              (let [result (-> {:status :ok}
                               (log "Cloning repo " repo "...")
                               (bind (fn [_] (clone-repo repo temp-dir)))
                               (bind (fn [_] (remove-dir queries-path)))
                               (bind (fn [_]
                                       (copy-dir (vim.fs.joinpath temp-dir (. queries :subfolder))
                                                 tsitter-path)))
                               (log "Queries copied to " queries-path))]
                (remove-dir temp-dir)
                result)
              (err "Could not create temporary folder."))))))

(fn build-all [parsers-path parsers force-rebuild]
  (let [statuses (reduce (fn [acc [parser repo]]
                           (let [result (add-parser parsers-path parser (. parsers parser :repo) force-rebuild)]
                             (assoc acc parser (= result.status :ok))))
                         {}
                         (kv-pairs parsers))
        fails (map first (filter (fn [[_ status]] (not status)) (kv-pairs statuses)))]
    (if (empty? fails)
        (ok (keys parsers))
        (err "Some parsers weren't built: " (str.join ", " fails) "."))))

(fn setup [tsitter-path parsers queries force-rebuild]
  (let [parsers-path (vim.fs.joinpath tsitter-path "parser")
        queries-path (vim.fs.joinpath tsitter-path "queries")
        result (-> (check-requirements ["clang" "tree-sitter"])
                   (bind (fn [_]
                           (if force-rebuild
                               (-> (remove-dir parsers-path)
                                   (bind (fn [_] (remove-dir queries-path))))
                               (ok))))
                   (bind (fn [_] (create-dir parsers-path)))
                   (bind (fn [_]
                           (do
                             (vim.opt.runtimepath:append tsitter-path)
                             (ok tsitter-path))))
                   (bind (fn [_]
                           (build-all parsers-path parsers force-rebuild)))
                   (bind (fn [_]
                           (add-queries tsitter-path queries force-rebuild))))]
    (if (not= result.status :ok)
        (vim.notify result.msg vim.log.levels.ERROR))))

(setup tsitter-path parsers queries)
