#!/usr/bin/env bb

(require '[babashka.process :refer [shell]]
         '[clojure.string :as str])

(def finger-touch "Wacom Pen and multitouch sensor Finger touch")
(def stilus-touch "Wacom Pen and multitouch sensor Pen stylus")

(def rotations
  [:normal :left :right :inverted])

(def matrixes
  {:normal   [ 1  0  0  0  1  0  0  0  1]
   :left     [ 0 -1  1  1  0  0  0  0  1]
   :right    [ 0  1  0 -1  0  1  0  0  1]
   :inverted [-1  0  1  0 -1  1  0  0  1]})

(def regex-rotation #"(\w+) connected primary [0-9x+]+ (?:(\w*) )?[(].*")

(defn get-output-and-rotation
  "Получает название текущего выхода и тип вращения."
  []
  (->> (shell {:out :string} "xrandr" "--query")
       :out
       str/split-lines
       (filter (partial re-matches regex-rotation))
       (map (fn [line]
              (when-let [m (re-matches regex-rotation line)]
                [(m 1) (keyword (or (m 2) :normal))])))
       first))

(let [[output rotation] (get-output-and-rotation)
      new-rotation (rotations (mod (inc (.indexOf rotations rotation))
                                   (count rotations)))]
  (if (or (= new-rotation :left) (= new-rotation :right))
    (shell "xinput" "disable" finger-touch)
    (shell "xinput" "enable" finger-touch))
  (shell "xrandr" "--output" output "--rotate" (name new-rotation))
  (apply shell (concat ["xinput" "set-prop" stilus-touch "Coordinate Transformation Matrix"] (matrixes new-rotation))))
