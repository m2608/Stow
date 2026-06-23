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
(straight-use-package 'evil-nerd-commenter)
(straight-use-package
 '(evil-surround :ensure t :config (global-evil-surround-mode 1)))
(straight-use-package 'evil-leader)
(straight-use-package 'evil-org-mode)
(straight-use-package 'telega)
(straight-use-package 'lsp-mode)
(straight-use-package 'w3m)
(straight-use-package 'vterm)
(straight-use-package 'restclient)
(straight-use-package 'magit)
(straight-use-package
 '(cider   :type git :host github :repo "clojure-emacs/cider" :branch "master"))
(straight-use-package
 '(clomacs :type git :host gitlab :repo "kostafey/clomacs"    :branch "master"))
(straight-use-package
 '(ejc-sql :type git :host github :repo "kostafey/ejc-sql"    :branch "master"))
(straight-use-package
 '(nano    :type git :host github :repo "rougier/nano-emacs"))

(require 'nano)
(require 'clomacs)
(require 'ejc-sql)

(setq nrepl-sync-request-timeout 60)
(setq clomacs-httpd-default-port 8090)

(require 'dired-x)
(setq dired-listing-switches "-alh --group-directories-first")
(setq dired-omit-files "^[.].*")

;; используем свою версию библиотеки tdlib
(setq telega-server-libs-prefix (concat (getenv "HOME") "/.local"))
;; нужно для нормального отображения эмодзи
(setq telega-emoji-use-images nil)

(evil-mode 1)

;; перейти к определению функции
(evil-define-key 'normal 'global "gd" 'lsp-find-definition)
;; :q не закрывает редактор, а закрывает только текущий буфер
(evil-ex-define-cmd "q" 'kill-this-buffer)
;; для закрытия редактора нужно будет написать :quit
(evil-ex-define-cmd "quit" 'evil-quit)

;; настройки evil-org-mode
(require 'evil-org)

;(add-hook 'org-mode-hook 'evil-org-mode)
;(require 'evil-org-agenda)
;(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
;(evil-org-agenda-set-keys)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql . t)
   (clojure . t)))

(setq org-confirm-babel-evaluate
      (lambda (lang body)
        (not (or (equal lang "sql") (equal lang "clojure")))) )

;; отключаем строку меню
(menu-bar-mode 0)

;; включаем относительные номера строк
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; вход в режим изменения размера шрифта (+/-)
(global-set-key (kbd "C-=") #'global-text-scale-adjust)

;; включаем стандартное поведение C-w в минибуфере
(define-key minibuffer-local-completion-map          (kbd "C-w") #'backward-kill-word)
(define-key minibuffer-local-filename-completion-map (kbd "C-w") #'backward-kill-word)

(add-hook
 'vterm-mode-hook
 (lambda ()
   ;; C-u посылаем в шел
   (define-key vterm-mode-map (kbd "C-u") #'vterm-send-C-u)))

(define-key global-map (kbd "C-c t") telega-prefix-map)

(add-hook
 'telega-chat-mode-hook
 (lambda ()
   (define-key telega-msg-button-map "j" 'next-line)
   (define-key telega-msg-button-map "k" 'previous-line)))

(add-hook
 'telega-root-mode-hook
 (lambda ()
   (define-key telega-root-mode-map "j" 'next-line)
   (define-key telega-root-mode-map "k" 'previous-line)
   ))

(setq telega-proxies
      (list
        '(:server "127.0.0.1" :port 5555 :enable t :type (:@type "proxyTypeSocks5"))))

(evil-set-initial-state 'telega-root-mode 'emacs)
(evil-set-initial-state 'telega-chat-mode 'emacs)
(evil-set-initial-state 'vterm-mode 'emacs)

;; в календаре первый день недели - понедельник
(setq calendar-week-start-day 1)

(setq warning-minimum-level :error)

;; fuzzy search в строке команд
(setq completion-styles '(flex))

;; load local init file if any
(let ((local-init (expand-file-name (concat "init#" (system-name) ".el") user-emacs-directory)))
  (when (file-exists-p local-init)
    (load-file local-init)))
