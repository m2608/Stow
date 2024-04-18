(local nvim (require "aniseed.nvim"))

{1 "ivanesmantovich/xkbswitch.nvim"
 :enabled (and (os.getenv "DISPLAY")
               (= 1 (nvim.fn.executable "xkb-switch")))
 :config
 (fn []
   (let [setup (. (require "xkbswitch") :setup)]
     (setup)))}
