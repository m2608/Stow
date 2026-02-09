{1 "nvim-treesitter/nvim-treesitter"
 ;; Проверяем наличие компилятора и tree-sitter.
 :cond (and (= 1 (vim.fn.executable "clang"))
            (= 1 (vim.fn.executable "tree-sitter")))
 :build ":TSUpdate"
 :config (fn []
           (let [ts (require "nvim-treesitter")]
             (ts.setup {:highlight {:enable true
                                    :additional_vim_regex_highlighting ["markdown"]}
                        :indent {:enable true}
                        :textobjects {:select {:enable true
                                               :keymaps {"af" "@function.outer"
                                                         "if" "@function.inner"}}}}))
           (vim.treesitter.language.register "clojure" "joker"))}
