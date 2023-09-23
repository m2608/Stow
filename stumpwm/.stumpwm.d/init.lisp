(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(in-package :stumpwm)
(setf *default-package* :stumpwm)

;; Окна stumpwm будут располагаться в центре экрана.
(setf *message-window-gravity* :top)
(setf *input-window-gravity* :top)

;; Фокус перемещается за мышью.
(setf *mouse-focus-policy* :sloppy)

;; Пример использования TrueType шрифтов. Недостаток: меньшая производительность, заметная
;; на глаз при отрисовке сообщений и диалогов.
(ql:quickload :clx-truetype)
(load-module "ttf-fonts")

(defcommand change-volume (change) ((:number nil))
            "Change current audio volume."
            (run-shell-command (format nil "mixer pcm ~@d" change) t)
            (multiple-value-bind (_ matches)
              (cl-ppcre:scan-to-strings ".*set to\\s+(\\d+):(\\d+)"
                                        (run-shell-command "exec mixer pcm" t))
              (let ((volume (/ (apply '+ (map 'list 'parse-integer matches)) 2)))
                (message (format nil "VOLUME: ~d" volume)))))

;; Команда для запуска SWANK REPL.
(require :swank)

(let ((server-running nil))
  (defcommand swank () ()
              "Toggle the swank server on/off."
              (if server-running
                (progn
                  (swank:stop-server 4005)
                  (message "Stopping swank.")
                  (setf server-running nil))
                (progn
                  (swank:create-server :port 4005
                                       :style swank:*communication-style*
                                       :dont-close t)
                  (message "Starting swank.")
                  (setf server-running t)))))

;; Настраиваем грячие клавиши.
(let ((shortcuts
        '(("s-j"     . "move-focus down")
          ("s-k"     . "move-focus up")
          ("s-l"     . "move-focus right")
          ("s-h"     . "move-focus left")
          ("s-J"     . "move-window down")
          ("s-K"     . "move-window up")
          ("s-L"     . "move-window right")
          ("s-H"     . "move-window left")
          ("s-u"     . "pull-hidden-next")
          ("s-i"     . "pull-hidden-previous")
          ("s-o"     . "windowlist")
          ("s-+"     . "vsplit")
          ("s-="     . "hsplit")
          ("s-DEL"   . "remove-split")
          ("s-S-DEL" . "delete")
          ("s-TAB"   . "fother")
          ("s-RET"   . "fullscreen")
          ("s-ESC"   . "exec alacritty")
          ("Print"   . "exec flameshot gui")
          ("XF86AudioRaiseVolume" . "change-volume +5")
          ("XF86AudioLowerVolume" . "change-volume -5")
          ("XF86AudioMute"        . "exec toggle-volume.sh")
          ("s-p" . "exec dmenu_run -fn \"Iosevka:size=14\" -nb \"#000000\" -nf \"#f0f0f0\" -sb \"#6f006f\"")
          ("S-Insert" . "exec clipmenu && sleep 0.5 && xclip -o | xdotool type --clearmodifiers --file -"))))
  (loop for shortcut in shortcuts
        do (stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd (car shortcut)) (cdr shortcut))))

;(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-ESC") "exec st")

;; Промежутки между окнами.
; (load-module "swm-gaps")
; (setf swm-gaps:*head-gaps-size*  0
;       swm-gaps:*inner-gaps-size* 0
;       swm-gaps:*outer-gaps-size* 0)
;
; (when *initializing*
;   (swm-gaps:toggle-gaps))

;; Запускаем скрипт синхронно, т.к. нужно добавить шрифты.
(stumpwm:run-shell-command "~/.stumpwm.d/autostart.sh" t)

(defun autostart (&rest rest)
  ;; Запускаем демонов.
  (stumpwm:run-shell-command "runsvdir ~/.runsvdir")
  ;; Добавляем переключение окон на доп. кнопки мыши.
  (stumpwm:run-shell-command "xbmouse -b 8 xkev -u -e u")
  (stumpwm:run-shell-command "xbmouse -b 9 xkev -u -e i")
  ; (stumpwm:set-font "-misc-spleen-*-*-*-*-24-*")
  (stumpwm:set-font (make-instance 'xft:font :family "Iosevka" :subfamily "Regular" :size 14)))

(defun autostop (&rest rest)
  ;; Останавливаем демонов.
  (run-shell-command "~/.stumpwm.d/autostop.sh"))

(add-hook *start-hook* 'autostart)
(add-hook *quit-hook* 'autostop)
