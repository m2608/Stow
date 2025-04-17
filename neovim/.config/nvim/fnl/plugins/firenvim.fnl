(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "glacambre/firenvim"
 :lazy (not nvim.g.started_by_firenvim)
 :build
 (fn []
   ((. nvim.fn "firenvim#install") 0))
 :config
 (fn []
   (core.assoc nvim.g "firenvim_config"
               {:globalSettings
                {:alt "all"}
                :localSettings
                {".*"
                 {:cmdline "neovim"
                  :content "text"
                  :priority 0
                  :selector "textarea"
                  :takeover "never"}}}))}

