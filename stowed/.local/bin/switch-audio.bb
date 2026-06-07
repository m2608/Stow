#!/usr/bin/env bb

(require
  '[babashka.process :refer [shell]]
  '[clojure.string :as str]
  '[cheshire.core :as json])

(defn find-sink-by-name
  "Находит в списке аудиовыход по имени."
  [sinks sink-name]
  (->> sinks
       (filter #(= (:name %) sink-name))
       first))

(defn get-sinks
  "Получает список аудиовыходов и оставляет только выходы, которые соответствуют шаблону."
  [pattern-string]
  (let [pattern (re-pattern pattern-string)
        sinks (-> (shell ["pactl" "--format=json" "list" "sinks"] {:out :string :err :discard})
                  :out
                  (json/parse-string true))]
    (->> sinks
         (filter #(re-find pattern (:description %)))
         (map #(select-keys % [:name :description :index :state])))))

(defn get-default-sink-name
  "Получает имя установленного в данный момент по умолчанию аудиовыхода."
  []
  (-> (shell ["pactl" "get-default-sink"] {:out :string})
      :out
      (str/split-lines)
      first))

(defn get-next-sink
  "Возвращает аудиовыход, на который мы будем преключаться. Это следующий аудиовыход
  после активного."
  [sinks current-sink-name]
  (->> sinks
       cycle
       (drop-while #(not= current-sink-name (:name %)))
       next
       first))

(defn switch-to-sink
  "Переключает аудиовыход, возвращает `true` в случае успеха."
  [sink]
  (-> (shell ["pactl" "set-default-sink" (:name sink)])
      :exit
      zero?))

(let [pattern (first *command-line-args*)]
  (if pattern
    (let [sinks (get-sinks pattern)]
      (if (seq sinks)
        (do (println (str "[INFO] Sinks found:\n\n" (str/join "\n" (map #(str "- " (:description %)) sinks)) "\n"))
            (let [current-sink-name (get-default-sink-name)
                  current-sink (find-sink-by-name sinks current-sink-name)
                  next-sink (get-next-sink sinks current-sink-name)]
              (println (format "[INFO] Current sink: «%s»" (:description current-sink)))
              (println (format "[INFO] Switching to sink «%s»..." (:description next-sink)))
              (if (switch-to-sink next-sink)
                (do (println "[INFO] Success")
                    (shell ["notify-send" (format "Audio output set to «%s»" (:description next-sink))]))
                (do (println "[ERROR] Could not switch")
                    (shell ["notify-send" (format "Can't change audio output to «%s»" (:description next-sink))])))))
        (println "[ERROR] No matching sinks found.")))
    (println "Usage: switch-audio.bb <pattern>")))
