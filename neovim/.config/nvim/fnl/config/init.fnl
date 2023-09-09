(each [_ mod (ipairs ["autocmds" "commands" "keymaps" "settings"])]
  (require (.. "config." mod)))
