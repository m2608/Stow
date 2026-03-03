(local {: filter} (require "nfnl.core"))

(fn starts-with? [s prefix]
  (= prefix (string.sub s 1 (length prefix))))

(fn cmd [...]
  (vim.cmd ...))

;; Команды для кодирования и декодирования base64 и URL.
(cmd (.. "command! -range URLencode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from urllib.parse import quote;"
         "print(quote(sys.stdin.read().strip()));"
         "\""))

(cmd (.. "command! -range URLdecode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from urllib.parse import unquote;"
         "print(unquote(sys.stdin.read().strip()));"
         "\""))

(cmd (.. "command! -range B64encode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from base64 import b64encode;"
         "print(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));"
         "\""))

(cmd (.. "command! -range B64decode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from base64 import b64decode;"
         "print(b64decode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));"
         "\""))

(cmd (.. "command! -range B64URLencode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from urllib.parse import quote;"
         "from base64 import b64encode;"
         "print(quote(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8')));"
         "\""))

(cmd (.. "command! -range URLB64decode :<line1>,<line2>"
         "!python3 -c \""
         "import sys;"
         "from urllib.parse import unquote;"
         "from base64 import b64decode;"
         "print(b64decode(unquote(sys.stdin.read().strip()).encode('utf-8')).decode('utf-8'));"
         "\""))

;; Команда для получения ссылки на исходный код в GitLab.
(vim.api.nvim_create_user_command
  "Gitlab"
  (fn [opts]
    (let [path (vim.fn.expand "%")
          line (vim.fn.line ".")]
      (case opts.args
        "open" (vim.system ["git" "browse" "-o" path line])
        "show" (vim.system ["git" "browse" "-s" path line] {:text true}
                           (fn [o]
                             (print o.stdout)))
        "yank" (vim.system ["git" "browse" "-s" path line] {:text true}
                           (fn [o]
                             (let [output (string.gsub (. o :stdout) "[\n]+$" "")]
                               (vim.schedule (fn [] (vim.call "OSCYank" output))))))
        _ (print (.. "Unknown subcommand: " opts.args)))))

  {:nargs 1
   :complete (fn [arglead _ _]
               (let [subcommands ["open" "show" "yank"]]
                 (filter (fn [c] (starts-with? c arglead)) subcommands)))
   :desc "Получить ссылку на исходный код в GitLab"})

;; Команда для показа изображений в терминале.
(vim.api.nvim_create_user_command
  "SixelView"
  (fn []
    (let [filename (vim.fn.expand "%:p")
          [row col] (vim.api.nvim_win_get_position 0)
          sixeldata (vim.fn.system (string.format "magick convert \"%s\" sixel:- 2> /dev/null" filename))]
      (vim.fn.chansend vim.v.stderr
                       (string.format "\27[s\27[%d;%dH%s\27[u" row (+ col 1) sixeldata))))
  {:nargs 0})
