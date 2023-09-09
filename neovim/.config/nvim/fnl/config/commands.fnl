(local {: autoload} (require "nfnl.module"))
(local nvim (autoload "nvim"))

(fn cmd [...]
  (nvim.command ...))

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
