(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

{1 "airblade/vim-gitgutter"
 :config
 (fn []
   (core.assoc nvim.g "gitgutter_map_keys" 0))}

