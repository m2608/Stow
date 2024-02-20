(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "JuliaEditorSupport/julia-vim"
 :config
 (fn []
   ;; (core.assoc nvim.g "latex_to_unicode_auto" 1)
   (core.assoc nvim.g "latex_to_unicode_file_types" ".*"))}
