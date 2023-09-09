(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

[{1 "preservim/tagbar"
  :config
  (fn []
    (core.assoc nvim.g "tagbar_ctags_bin" "/usr/local/bin/uctags"))}]
