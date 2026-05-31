{1 "stevearc/oil.nvim"
 :lazy true
 :config
 (fn []
   (let [setup (. (require "oil") :setup)]
     (setup
       {:default_file_explorer true
        :columns ["permissions" "size" "icon"]
        :keymaps {
            "."    {1 "actions.toggle_hidden" :mode "n"}
            "<BS>" {1 "actions.parent"        :mode "n"}}
        :float        {:override (fn []
                                   (let [col 10 row 4
                                             w (- vim.o.columns (* 2 col))
                                             h (- vim.o.lines   (* 2 row) 4)]
                                     {:relative :editor :anchor "NW"
                                      :col col :row row :width w :height h
                                      :border ["┌" "─" "┐" "│" "┘" "─" "└" "│"]}))}
        :progress     {:border "single"}
        :confirmation {:border "single"}
        :ssh          {:border "single"}
        :keymaps_help {:border "single"}
        })))
 :cmd ["Oil"]}
