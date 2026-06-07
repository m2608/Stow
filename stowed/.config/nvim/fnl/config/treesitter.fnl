(local {: merge : first : filter : empty? : identity} (require "nfnl.core"))
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

(fn run [cmd opts]
  (let [p (vim.system cmd (merge {:text true} opts))]
    (let [r (p:wait)]
      (if (= 0 (. r :code))
          (. r :stdout)
          (error (.. "Error running command: " (str.join " " cmd)))))))

(fn build-grammar [parser]
  (let [repo (. parsers parser)]
    (if repo
        (let [temp-folder (-> (run ["mktemp" "-d"]) (str.split "\n") first)]
          (print (.. "Cloning parser \"" parser "\"..."))
          (run ["git" "clone" "--depth=1" (.. "https://github.com/" repo) temp-folder])

          (print (.. "Building parser \"" parser "\"..."))
          (run ["tree-sitter" "build"] {:cwd temp-folder})

          (let [parser-lib (first (vim.fn.readdir temp-folder
                                                  (fn [s]
                                                    (str.ends-with? s ".so"))))]
            (if parser-lib
                (vim.uv.fs_copyfile (vim.fs.joinpath temp-folder parser-lib)
                                    (vim.fs.joinpath parsers-path (.. parser ".so")))
                (error (.. "Could not find compile library for parser \"" parser "\"."))))

          (vim.fs.rm temp-folder {:recursive true})
          (print (.. "Parser \"" parser "\" installed successfully.")))
        (error (.. "Could not find repository for parser \"" parser "\".")))))

(fn check-requirement [req]
  (if (not= 1 (vim.fn.executable req))
      (error (.. "Tool required for tree-sitter: " req) 0)))

(fn check-requirements [reqs]
  (let [(s r) (pcall (fn []
                       (each [(_ req) (ipairs reqs)]
                         (check-requirement req))))]
    (or s (print r))))

(check-requirements ["clang" "tree-sitter" "xxxaaa"])

; (if (and (check-requirements ["clang" "tree-sitter"])
;          ))

(if (not (vim.uv.fs_stat parsers-path))
  (run ["mkdir" "-p" parsers-path]))

(vim.opt.runtimepath:append tsitter-path)

(build-grammar :clojure)
