(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

[{1 "kkharji/lispdocs.nvim"
  :lazy true
  :dependencies ["kkharji/sqlite.lua"]
  :config
  (fn []
    (core.assoc nvim.g "lispdocs_mappings" 0))}]
