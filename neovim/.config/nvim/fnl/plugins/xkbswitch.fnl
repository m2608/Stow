(local nvim (require "aniseed.nvim"))

{1 "ivanesmantovich/xkbswitch.nvim"
 :enabled (and (not= nil (os.getenv "DISPLAY"))
               (= 1 (nvim.fn.executable "xkb-switch")))
 :config true}
