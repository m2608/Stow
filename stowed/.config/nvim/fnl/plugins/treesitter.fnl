(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

{1 "nvim-treesitter/nvim-treesitter"
 ;; Проверяем наличие компилятора и tree-sitter.
 :cond (and (= 1 (vim.fn.executable "clang"))
            (= 1 (vim.fn.executable "tree-sitter")))
 :build ":TSUpdate"
 :config (fn []
           (vim.api.nvim_create_autocmd
             ["FileType"]
             {:pattern ["clojure"]
              :callback (fn []
                          (vim.treesitter.start))})
           (vim.api.nvim_create_autocmd
             ["FileType"]
             {:pattern ["joker" "fennel" "python"]
              :callback (fn []
                          (vim.treesitter.start)
                          (tset vim.bo "indentexpr" "v:lua.require'nvim-treesitter'.indentexpr()"))}))}
