{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-ai (require "mini.ai")
                 mini-surround (require "mini.surround")
                 mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")]
             (mini-ai.setup
               {:search_method "cover"})
             (mini-surround.setup
               {:mappings
                {:add "ys"
                 :delete "ds"
                 :replace "cs"
                 :find ""
                 :find_left ""
                 :highlight ""
                 :update_n_lines ""
                 :suffix_last ""
                 :suffix_next ""}})
             (mini-jump.setup {})
             (mini-bracketed.setup {})))}
