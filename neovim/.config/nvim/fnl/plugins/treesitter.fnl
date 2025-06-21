{1 "nvim-treesitter/nvim-treesitter"

 ;; Проверяем наличие компилятора и tree-sitter.
 :cond
 (and (= 1 (vim.fn.executable "clang"))
      (= 1 (vim.fn.executable "tree-sitter")))

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
       {:highlight {:enable true
                    :additional_vim_regex_highlighting ["markdown"]}
       :indent {:enable true}
       :playground {:enabled true}
       :textobjects
       {:select
        {:enable true
         :keymaps
         {"af" "@function.outer"
          "if" "@function.inner"}}}})
     ; (vim.treesitter.language.register "clojure" "joker")
     ))}
