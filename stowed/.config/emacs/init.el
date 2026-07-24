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

(straight-use-package 'evil)
(straight-use-package 'evil-nerd-commenter)
(straight-use-package
 '(evil-surround :ensure t :config (global-evil-surround-mode 1)))
(straight-use-package 'evil-leader)
(straight-use-package 'evil-org-mode)
(straight-use-package 'helm)
(straight-use-package 'telega)
(straight-use-package 'lsp-mode)
(straight-use-package 'w3m)
(straight-use-package 'vterm)
(straight-use-package 'restclient)
(straight-use-package 'ob-restclient)
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

;;
;; EVIL MODE SETTINGS
;;

(setq evil-want-C-u-scroll t)

(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(defun my/evil-shift-right-keep-visual (beg end count)
  "Сдвигает выделенный текст вправо, сохраняя выделение."
  (interactive "r\np")
  (evil-shift-right beg end count)
  (evil-visual-restore))

(defun my/evil-shift-left-keep-visual (beg end count)
  "Сдвигает выделенный текст влево, сохраняя выделение."
  (interactive "r\np")
  (evil-shift-left beg end count)
  (evil-visual-restore))

;; перейти к определению функции
(evil-define-key 'normal 'global "gd" 'lsp-find-definition)
;; :q не закрывает редактор, а закрывает только текущий буфер
(evil-ex-define-cmd "q" 'kill-this-buffer)
;; для закрытия редактора нужно будет написать :quit
(evil-ex-define-cmd "quit" 'evil-quit)

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "SPC b") #'helm-buffers-list)
  (evil-define-key 'normal 'global (kbd "SPC f") #'helm-find-files)
  (evil-define-key 'normal 'global (kbd "SPC g") #'helm-occur)
  (evil-define-key 'normal 'global (kbd "SPC /") #'helm-do-grep-ag)
  ; хоткеи для сдвигания выделенного текста
  (evil-define-key 'visual evil-org-mode-map (kbd "<") #'my/evil-shift-left-keep-visual)
  (evil-define-key 'visual evil-org-mode-map (kbd ">") #'my/evil-shift-right-keep-visual)
  (evil-define-key 'visual evil-org-mode-map (kbd "gc") #'comment-dwim))

;;
;; ORG MODE SETTINGS
;;
(require 'evil-org)

(add-hook 'org-mode-hook 'evil-org-mode)

(defun my/org-copy-raw-link ()
  "Копировать ссылку из Org Mode."
  (interactive)
  (let ((href (org-element-property :raw-link (org-element-context))))
    (if href
        (progn
          (kill-new href)
          (message "Copied link: %s" href))
      (message "No Org link at point."))))

(with-eval-after-load 'org
  ; на клавиатуре нет TAB, заменяем на C-i
  (evil-define-key 'normal evil-org-mode-map (kbd "C-i") #'org-cycle)
  ; возвращаем стандартное поведение для некоторых сочетаний
  (evil-define-key 'normal evil-org-mode-map (kbd "J") #'evil-join)
  (evil-define-key 'normal evil-org-mode-map (kbd "t") #'evil-find-char-to)
  (evil-define-key 'normal evil-org-mode-map (kbd "O") #'evil-open-above)
  ; Копирование ссылки.
  (define-key org-mode-map (kbd "C-c y") #'my/org-copy-link-url))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql        . t)
   (clojure    . t)
   (python     . t)
   (restclient . t)))

(setq org-confirm-babel-evaluate
      (lambda (lang body)
        (not (member lang '("clojure" "python" "restclient" "sql")))))

;; отключить дефолтный отступ для содержимого src-блоков в org-mode
(setq org-edit-src-content-indentation 0)

;;
;; TELEGA
;;

(global-display-line-numbers-mode)

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

;;
;; VTERM
;;

(add-hook
 'vterm-mode-hook
 (lambda ()
   ;; C-u посылаем в шел
   (define-key vterm-mode-map (kbd "C-u") #'vterm-send-C-u)))

(evil-set-initial-state 'vterm-mode 'emacs)

;;
;; OTHER SETTINGS
;;

;; отключаем строку меню
(menu-bar-mode 0)

;; включаем относительные номера строк
(setq display-line-numbers-type 'relative)
;; вход в режим изменения размера шрифта (+/-)
(global-set-key (kbd "C-=") #'global-text-scale-adjust)

;; включаем стандартное поведение C-w в минибуфере
(define-key minibuffer-local-completion-map          (kbd "C-w") #'backward-kill-word)
(define-key minibuffer-local-filename-completion-map (kbd "C-w") #'backward-kill-word)

;; в календаре первый день недели - понедельник
(setq calendar-week-start-day 1)

(setq warning-minimum-level :error)

;; fuzzy search в строке команд
(setq completion-styles '(flex))

;; Отключаем nxml-mode, т.к. он виснет на billion loughs.
(setq auto-mode-alist
      (rassq-delete-all 'nxml-mode auto-mode-alist))

(add-to-list 'auto-mode-alist '("\\.xml\\'" . sgml-mode))

;;
;; LOAD LOCAL INIT FILE IF ANY
;;

(let ((local-init (expand-file-name (concat "init#" (system-name) ".el") user-emacs-directory)))
  (when (file-exists-p local-init)
    (load-file local-init)))
