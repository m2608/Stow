(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-pinned-packages '(telega . "melpa-stable"))
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages
   '(restclient-jq restclient slime telega language-detection ecb w3m evil-nerd-commenter evil-surround evil))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "M+ 2m" :foundry "M+  " :slant normal :weight normal :height 140 :width normal)))))

(setq evil-want-C-u-scroll t)
(require 'evil)
;;(require 'org-evil)
(evil-mode 1)
;; :q не закрывает редактор, а закрывает только текущий буфер
(evil-ex-define-cmd "q" 'kill-this-buffer)
;; для закрытия редактора нужно будет написать :quit
(evil-ex-define-cmd "quit" 'evil-quit)

(menu-bar-mode 0)
(line-number-mode 1)

(define-key global-map (kbd "C-c t") telega-prefix-map)

(add-hook
 'telega-chat-mode-hook
 (lambda ()
   ;; Шрифт для отображения моноширинного текста в Телеграме. Делаем его таким же, как
   ;; основной.
   (set-face-attribute 'telega-entity-type-code nil :font "M+ 2m")
   (set-face-attribute 'telega-entity-type-pre nil :font "M+ 2m")
   (define-key telega-msg-button-map "k" nil)
   (define-key telega-msg-button-map "l" nil)
   (define-key telega-msg-button-map "x" 'kill-current-buffer)))
