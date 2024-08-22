{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")
                 mini-status (require "mini.statusline")]
             (mini-jump.setup {})
             (mini-bracketed.setup {})
             (mini-status.setup {})))}
