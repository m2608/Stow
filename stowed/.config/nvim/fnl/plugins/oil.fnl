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
        :float        {:border "single" :padding 10}
        :progress     {:border "single"}
        :confirmation {:border "single"}
        :ssh          {:border "single"}
        :keymaps_help {:border "single"}
        })))
 :cmd ["Oil"]}
