{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-surround (require "mini.surround")
                 mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")
                 mini-hipatterns (require "mini.hipatterns")]
             (mini-surround.setup {})
             (mini-jump.setup {})
             (mini-bracketed.setup {})
             (mini-hipatterns.setup
               {:highlighters
                {:fixme {:pattern "%f[%w]()FIXME()%f[%W]" :group "MiniHipatternsFixme"}
                 :hack  {:pattern "%f[%w]()HACK()%f[%W]"  :group "MiniHipatternsHack"}
                 :todo  {:pattern "%f[%w]()TODO()%f[%W]"  :group "MiniHipatternsTodo"}
                 :note  {:pattern "%f[%w]()NOTE()%f[%W]"  :group "MiniHipatternsNote"}}
                :hex_color (mini-hipatterns.gen_highlighter.hex_color)})))}
