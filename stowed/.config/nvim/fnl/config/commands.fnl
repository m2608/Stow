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

;; Команда для открытия текущей строки исходного кода в GitLab.
;; Для работы нужен скрипт git-browse.
(cmd (.. "command! -range GitLab "
         "execute 'silent ! git browse \"' . expand('%') . '\" ' . <line1> | checktime | redraw!"))

;; Эта команда просто показывает ссылку.
(cmd (.. "command! -range GitLabShow "
         "execute '! git browse -s \"' . expand('%') . '\" ' . <line1>"))

;; Команда копирует ссылку на GitLab в буфер обмена (через OSC52).
(vim.api.nvim_create_user_command
  "GitLabYank"
  (fn []
    (let [command ["git" "browse" "-s" (vim.fn.expand "%") (tostring (vim.fn.line "."))]]
      (vim.system command {:text true}
                  (fn [o]
                    (let [output (string.gsub (. o :stdout) "[\n]+$" "")]
                      (vim.schedule (fn [] (vim.call "OSCYank" output))))))))
  {:nargs 0})

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
