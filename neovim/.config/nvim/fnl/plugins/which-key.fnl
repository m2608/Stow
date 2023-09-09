(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

[{1 "folke/which-key.nvim"
  :config
  (fn []
    (core.assoc nvim.o :timeout true)
    (core.assoc nvim.o :timeoutlen 300)
    ((. (require "which-key") :setup) {}))}] 
