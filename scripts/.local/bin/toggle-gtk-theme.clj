#!/usr/bin/env bb

(def ini (str (System/getenv "HOME")
              "/.config/gtk-3.0/settings.ini"))

(def themes {:dark "Adwaita-dark"
             :light "Adwaita"})

(let [[new-theme] *command-line-args*]
  (->> (slurp ini)
       clojure.string/split-lines
       (map (fn [line]
              (if-let [m (re-matches #"^(gtk-theme-name[ ]*=[ ]*)[A-Za-z]+(-dark)?" line)]
                (str (m 1)
                     (case new-theme
                       "dark"  (themes :dark)
                       "light" (themes :light)
                       (if (m 2)
                         (themes :light)
                         (themes :dark))))
                line)))
       (clojure.string/join "\n")
       (spit ini)))
