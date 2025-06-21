(local core (require "nfnl.core"))

{1 "kkharji/lispdocs.nvim"
 :lazy true
 :dependencies ["kkharji/sqlite.lua"]
 :config
 (fn []
   (core.assoc vim.g "lispdocs_mappings" 0))}
