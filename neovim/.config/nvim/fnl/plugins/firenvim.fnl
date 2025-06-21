(local core (require "nfnl.core"))

{1 "glacambre/firenvim"
 :lazy (not vim.g.started_by_firenvim)
 :build
 (fn []
   ((. vim.fn "firenvim#install") 0))
 :config
 (fn []
   (core.assoc vim.g "firenvim_config"
               {:globalSettings
                {:alt "all"}
                :localSettings
                {".*"
                 {:cmdline "neovim"
                  :content "text"
                  :priority 0
                  :selector "textarea"
                  :takeover "never"}}}))}

