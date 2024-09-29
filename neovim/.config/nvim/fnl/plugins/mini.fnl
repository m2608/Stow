{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")
                 mini-status (require "mini.statusline")
                 ms (fn [section truncate-width]
                      ((. MiniStatusline (.. "section_" section)) {:trunc_width truncate-width}))]
             (mini-jump.setup {})
             (mini-bracketed.setup {})))}
