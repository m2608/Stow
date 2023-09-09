(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

[{1 "glacambre/firenvim"
  :lazy (not nvim.g.started_by_firenvim)
  :build
  (fn []
    ((. nvim.fn "firenvim#install")))
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
                   :takeover "never"}}}))}]

