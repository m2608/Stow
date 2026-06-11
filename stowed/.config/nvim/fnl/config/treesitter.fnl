(local {: merge : first : map : filter : empty? : identity : reduce} (require "nfnl.core"))
(local str  (require "nfnl.string"))

(local parsers {
  :clojure         "sogaiu/tree-sitter-clojure"
  :cpp             "tree-sitter/tree-sitter-cpp"
  :fennel          "alexmozaidze/tree-sitter-fennel"
  :html            "tree-sitter/tree-sitter-html"
  :hurl            "pfeiferj/tree-sitter-hurl"
  :janet_simple    "sogaiu/tree-sitter-janet-simple"
  :js              "tree-sitter/tree-sitter-javascript"
  :jq              "flurie/tree-sitter-jq"
  :json            "tree-sitter/tree-sitter-json"
  :make            "tree-sitter-grammars/tree-sitter-make"
  :markdown        "tree-sitter-grammars/tree-sitter-markdown"
  :markdown_inline "tree-sitter-grammars/tree-sitter-markdown"
  :python          "tree-sitter/tree-sitter-python"
  :scheme          "6cdh/tree-sitter-scheme"
  :sql             "derekstride/tree-sitter-sql"
  :xml             "tree-sitter-grammars/tree-sitter-xml"
  :yaml            "tree-sitter-grammars/tree-sitter-yaml"
})

(local tsitter-path (vim.fs.joinpath (os.getenv "HOME") ".local/share/nvim/treesitter"))
(local parsers-path (vim.fs.joinpath tsitter-path "parser"))

(fn ok [val]
  {:status :ok :val val})

(fn err [...]
  {:status :err :msg (str.join [...])})

(fn bind [result f]
  (if (= result.status :ok)
      (f result.val)
      result))

(fn run [cmd opts]
  (let [p (vim.system cmd (merge {:text true} opts))]
    (p:wait)))

(fn check-requirements [rs]
  (let [fails (filter (fn [r] (= 0 (vim.fn.executable r))) rs)]
    (print (vim.inspect fails))
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

(fn create-temp-dir
  [path]
  "Создаёт временный каталог. В случае успеха возвращает путь к нему."
  (let [r (run ["mktemp" "-d"])]
    (if (= 0 r.code)
        (ok (first (str.split r.stdout "\n")))
        (err "Could not create temporary folder."))))

(fn remove-dir
  [path]
  (let [(_ e) (vim.fs.rm path {:recursive true})]
    (if (not e)
        (ok path)
        (err "Could not remove folder: " path))))

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

(fn copy-parser [lib-path dst]
  (let [(_ e) (vim.uv.fs_copyfile lib-path dst)]
    (if (not e)
        (ok dst)
        (err "Could not copy " lib-path " into " dst "."))))

; (fn build-grammar [parser]
;   (let [repo (. parsers parser)]
;     (if repo
;         (let [temp-folder (-> (run ["mktemp" "-d"]) (str.split "\n") first)]
;           (print (.. "Cloning parser \"" parser "\"..."))
;           (run ["git" "clone" "--depth=1" (.. "https://github.com/" repo) temp-folder])
;
;           (print (.. "Building parser \"" parser "\"..."))
;           (run ["tree-sitter" "build"] {:cwd temp-folder})
;
;           (let [parser-lib (first (vim.fn.readdir temp-folder
;                                                   (fn [s]
;                                                     (str.ends-with? s ".so"))))]
;             (if parser-lib
;                 (vim.uv.fs_copyfile (vim.fs.joinpath temp-folder parser-lib)
;                                     (vim.fs.joinpath parsers-path (.. parser ".so")))
;                 (error (.. "Could not find compile library for parser \"" parser "\"."))))
;
;           (vim.fs.rm temp-folder {:recursive true})
;           (print (.. "Parser \"" parser "\" installed successfully.")))
;         (error (.. "Could not find repository for parser \"" parser "\".")))))

(fn build [parser]
  (let [repo (. parsers parser)
        r (-> (create-temp-dir)
              (bind (fn [r] (clone-repo repo r.val))))]
    ))

;
; (fn build-all [parsers]
;   (let [fails (filter build parsers)]
;     (if (empty? fails)
;         (ok parsers)
;         (err (.. "Some parsers weren't built: " (str.join ", " fails) ".")))))


; (-> (check-requirements ["clang" "tree-sitter"])
;     (bind (fn [_] (create-dir parsers-path)))
;     (bind (fn [_] (build-all parsers)))
;     (bind (fn [_] (vim.opt.runtimepath:append tsitter-path))))


