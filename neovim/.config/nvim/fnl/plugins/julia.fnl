(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

[{1 "JuliaEditorSupport/julia-vim"
  :config
  (fn []
    ;; (core.assoc nvim.g "latex_to_unicode_auto" 1)
    (core.assoc nvim.g "latex_to_unicode_file_types" ".*"))}]
