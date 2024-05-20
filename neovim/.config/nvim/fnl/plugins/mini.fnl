{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-ai (require "mini.ai")
                 mini-surround (require "mini.surround")
                 mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")]
             (mini-ai.setup {})
             (mini-surround.setup {})
             (mini-jump.setup {})
             (mini-bracketed.setup {})))}
