#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[babashka.process :refer [shell]])

(def device "amdgpu_bl0")

(def br-file-val (format "/sys/class/backlight/%s/brightness" device))
(def br-file-max (format "/sys/class/backlight/%s/max_brightness" device ))

(def help "
Usage examples:

- brightness +10%
- brightness -25%
- brightness  50%
")

(defn get-br-value
  "Возвращает значение яркости."
  [file]
  (-> (slurp file) str/split-lines first Integer/parseInt))

(defn set-br-value
  [value]
  (shell ["busctl" "call" "org.freedesktop.login1" "/org/freedesktop/login1/session/self" "org.freedesktop.login1.Session"
          "SetBrightness" "ssu" "backlight" device (str value)]))

(def br-default 100000)
(def br-max (get-br-value br-file-max))

(defn ->percent
  "Преобразует значение яркости в проценты."
  [value]
  (-> (/ value br-max) (* 100) int (min 100)))

(defn ->value
  "Преобразует процент яркости в значение."
  [percent]
  (-> percent (* br-max) (/ 100) int))

(defn change-relative
  "Возвращает новое значение яркости для переданной дельты (в процентах)."
  [delta]
  (-> (get-br-value br-file-val) ->percent (+ delta) (max 0) (min 100) ->value))

(let [[command] *command-line-args*]
  (if command
    (let [[_ delta   :as relative] (re-matches #"^([+-][0-9]+)%$" command)
          [_ percent :as absolute] (re-matches #"^([0-9]+)%$"     command)]
      (cond
        relative (set-br-value (change-relative (Integer/parseInt delta)))
        absolute (set-br-value (->value (Integer/parseInt percent)))
        :else    (println help)))
    (do (println help)
        (System/exit 1))))

