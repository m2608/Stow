(local nvim (require "aniseed.nvim"))

{1 "nvim-treesitter/nvim-treesitter"

 ;; Проверяем наличие компилятора и tree-sitter.
 :cond
 (and (= 1 (nvim.fn.executable "clang"))
      (= 1 (nvim.fn.executable "tree-sitter")))

 :build
 (fn []
   (let [ts-install (require "nvim-treesitter.install")]
     ((. ts-install :update) {:with_sync true})))

 :config
 (fn []
   ;; настройка treesitter, для автоматической компиляции нужно установить tree-sitter-cli
   ;; gcc в CentOS очень старые, есть проблемы с компиляцией некоторых парсеров, поэтому
   ;; будем использовать clang
   (let [ts-install (require "nvim-treesitter.install")
         ts-configs (require "nvim-treesitter.configs")]
     (tset ts-install :compilers ["clang"])
     (ts-configs.setup
      {:ensure_installed
       ["c"
        "clojure"
        "comment"
        "commonlisp"
        "cpp"
        "css"
        "diff"
        "dockerfile"
        "dot"
        "fennel"
        "fish"
        "html"
        "ini"
        "javascript"
        "jq"
        "json"
        "lua"
        "make"
        "markdown"
        "markdown_inline"
        "python"
        "query"
        "scheme"
        "sql"
        "toml"
        "typescript"
        "vimdoc"
        "vue"]
       :highlight {:enable true
                   :additional_vim_regex_highlighting ["markdown"]}
       :indent {:enable true}
       :playground {:enabled true}})))}
