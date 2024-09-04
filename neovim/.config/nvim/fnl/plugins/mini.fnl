{1 "echasnovski/mini.nvim"
 :version false
 :config (fn []
           (let [mini-jump (require "mini.jump")
                 mini-bracketed (require "mini.bracketed")
                 mini-status (require "mini.statusline")
                 ms (fn [section truncate-width]
                      ((. MiniStatusline (.. "section_" section)) {:trunc_width truncate-width}))]
             (mini-jump.setup {})
             (mini-bracketed.setup {})
             (mini-status.setup
               {:content
                {:active 
                 (fn []
                   (let [(mode mode_hl) (ms "mode"       120)
                         filename       (ms "filename"  1024)
                         fileinfo       (ms "fileinfo"   120)
                         location       (ms "location"  1024)
                         search         (ms "searchcount" 75)]
                     (MiniStatusline.combine_groups
                       [{:hl mode_hl                  :strings [mode]}
                        "%<"
                        {:hl "MiniStatuslineFilename" :strings [filename]}
                        "%="
                        {:hl "MiniStatuslineFileinfo" :strings [fileinfo]}
                        {:hl mode_hl                  :strings [search location]}])))
                 :inactive nil}})))}
