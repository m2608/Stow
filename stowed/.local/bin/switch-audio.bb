#!/usr/bin/env bb

(require
  '[babashka.process :refer [shell]]
  '[clojure.string :as str]
  '[cheshire.core :as json])

(defn find-by-short-name
  "Находит в списке аудиовыход по «короткому имени» (началу описания текстового аудиовыхода)."
  [sinks short-name]
  (let [matched-sinks (filter #(str/starts-with? (:description %) short-name) sinks)]
    (when (seq matched-sinks)
      (-> matched-sinks
          first
          (select-keys [:name :description :index :state])
          (assoc :short-name short-name)))))

(defn find-sink-by-name
  "Находит в списке аудиовыход по имени."
  [sinks sink-name]
  (->> sinks
       (filter #(= (:name %) sink-name))
       first))

(defn get-sinks
  "Получает список аудиовыходов и оставляет только выходы с указанными «короткими именами»."
  [short-names]
  (let [sinks (-> (shell ["pactl" "--format=json" "list" "sinks"] {:out :string})
                  :out
                  (json/parse-string true))]
    (->> short-names
         (map #(find-by-short-name sinks %))
         (filterv identity))))

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

(let [short-names *command-line-args*]
  (if (and (seq short-names) (>= (count short-names) 2))
    (let [sinks (get-sinks ["B10" "Rembrandt" "AAA"])]
      (if (seq sinks)
        (do (println (str "[INFO] Sinks found:\n\n" (str/join "\n" (map #(str "- " (:description %)) sinks)) "\n"))
            (let [current-sink-name (get-default-sink-name)
                  current-sink (find-sink-by-name sinks current-sink-name)
                  next-sink (get-next-sink sinks current-sink-name)]
              (println (format "[INFO] Current sink: «%s»" (:description current-sink)))
              (println (format "[INFO] Switching to sink «%s»..." (:description next-sink)))
              (if (switch-to-sink next-sink)
                (do (println "[INFO] Success")
                    (shell ["notify-send" (format "Audio output set to «%s»" (:short-name next-sink))]))
                (do (println "[ERROR] Could not switch")
                    (shell ["notify-send" (format "Can't change audio output to «%s»" (:short-name next-sink))])))))
        (println "[ERROR] No matching sinks found.")))
    (println "Usage: switch-audio.bb <sink1> <sink2> ...")))
