{1 "nvim-lualine/lualine.nvim"
 :dependencies ["nvim-tree/nvim-web-devicons"]
 :config (fn []
           (let [setup (. (require "lualine") :setup)]
             (setup {:options
                     {:icons_enabled false
                      :theme :auto
                      :component_separators {:left "|" :right "|"}
                      :section_separators {:left "" :right ""}}
                     :sections
                     {:lualine_c
                      [{1 "filename"
                        :path 1}]}})))}
