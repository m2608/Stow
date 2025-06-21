(local core (require "nfnl.core"))

{1 "JuliaEditorSupport/julia-vim"
 :config
 (fn []
   ;; (core.assoc vim.g "latex_to_unicode_auto" 1)
   (core.assoc vim.g "latex_to_unicode_file_types" ".*"))}
