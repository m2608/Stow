(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "kkharji/lispdocs.nvim"
 :lazy true
 :dependencies ["kkharji/sqlite.lua"]
 :config
 (fn []
   (core.assoc nvim.g "lispdocs_mappings" 0))}
