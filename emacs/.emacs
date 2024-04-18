(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq evil-want-C-u-scroll t)

(straight-use-package 'evil)
(straight-use-package 'telega)
(straight-use-package 'lsp-mode)
(straight-use-package 'w3m)
(straight-use-package 'vterm)
(straight-use-package 'restclient)
(straight-use-package
  '(nano :type git :host github :repo "rougier/nano-emacs"))

(require 'nano)

(setq telega-server-libs-prefix (concat (getenv "HOME") "/.local"))

(evil-mode 1)
;; перейти к определению функции
(evil-define-key 'normal 'global "gd" 'lsp-find-definition)
;; :q не закрывает редактор, а закрывает только текущий буфер
(evil-ex-define-cmd "q" 'kill-this-buffer)
;; для закрытия редактора нужно будет написать :quit
(evil-ex-define-cmd "quit" 'evil-quit)

;; отключаем строку меню
(menu-bar-mode 0)

;; включаем относительные номера строк
(setq display-line-numbers 'relative)

(define-key global-map (kbd "C-c t") telega-prefix-map)

(add-hook
 'telega-chat-mode-hook
 (lambda ()
   (define-key telega-msg-button-map "k" nil)
   (define-key telega-msg-button-map "l" nil)
   (define-key telega-msg-button-map "x" 'kill-current-buffer)))

;; в календаре первый день недели - понедельник
(setq calendar-week-start-day 1)
