(local {: autoload} (require "nfnl.module"))
(local nvim (autoload "nvim"))

[{1 "nvim-treesitter/nvim-treesitter"
  :cond
  ;; Проверяем наличие компилятора и tree-sitter.
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

      ((. ts-configs "setup")
       {:ensure_installed
        ["c"
         "clojure"
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
         "python"
         "scheme"
         "sql"
         "toml"
         "typescript"
         "vue"
         "yaml"]
        :highlight {:enable true}
        :indent {:enable false}})))}]
