(local {: autoload} (require "nfnl.module"))

(local augroup vim.api.nvim_create_augroup)
(local autocmd vim.api.nvim_create_autocmd)

;; Добавляем типа файлов "joker".
(vim.filetype.add {:extension {"jk" "joker"}})


(augroup "joker" {:clear true})

(autocmd
  ["FileType"]
  {:pattern "joker"
   :group "joker"
   :command "runtime! indent/clojure.vim"})

