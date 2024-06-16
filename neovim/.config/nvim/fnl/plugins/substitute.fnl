{1 "gbprod/substitute.nvim"
 :config (fn []
           (let [substitute (require "substitute")]
             (substitute.setup {})
             (vim.keymap.set "n" "s" substitute.operator {:noremap true})
             (vim.keymap.set "x" "s" substitute.visual {:noremap true})))}
