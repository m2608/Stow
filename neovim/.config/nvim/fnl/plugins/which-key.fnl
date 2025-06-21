(local core (require "nfnl.core"))

{1 "folke/which-key.nvim"
 :config
 (fn []
   (core.assoc vim.o :timeout true)
   (core.assoc vim.o :timeoutlen 300)
   ((. (require "which-key") :setup) {}))}
