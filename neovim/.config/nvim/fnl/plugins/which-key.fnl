(local nvim (require :aniseed.nvim))
(local core (require :aniseed.core))

{1 "folke/which-key.nvim"
 :config
 (fn []
   (core.assoc nvim.o :timeout true)
   (core.assoc nvim.o :timeoutlen 300)
   ((. (require "which-key") :setup) {}))}
