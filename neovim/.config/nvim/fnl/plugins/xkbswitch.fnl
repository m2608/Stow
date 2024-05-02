(local nvim (require "aniseed.nvim"))

(fn xorg-running? []
  "Проверяет, что X-сервер запущен на текущем $DISPLAY."
  (vim.fn.system "xset -q")
  (= vim.v.shell_error 0))

{1 "ivanesmantovich/xkbswitch.nvim"
 :enabled (and (not= nil (os.getenv "DISPLAY"))
               (= 1 (nvim.fn.executable "xkb-switch"))
               (xorg-running?))
 :config true}
