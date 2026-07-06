#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[clojure.edn :refer [read-string]])

(defn spaces
  "Возвращает `n` пробелов."
  [n]
  (str/join "" (repeat n " ")))

(defn right-pad
  "Возвращает указанную строку с добавленными справа до длины `n` пробелами."
  [n s]
  (str s (spaces (max (- n (count s)) 0))))

(declare convert-value convert-map)

(defn convert-value
  "Форматирует значение в представление, пригодное для использования в scheme."
  [v indent]
  (cond
    (string? v)  (str \" v \")
    (keyword? v) (name v)
    (vector? v)  (str "(" (str/join " " (map #(convert-value % indent) v)) ")")
    (map? v)     (convert-map v indent)
    :else        v))

(defn convert-map
  "Преобразует мапу к списку пар, который в scheme используется для хранения
  ключей и значений. Возвращает строку, которую сможет прочитать интерпретатор
  scheme.
  
  {:a 1 :b :two} -> ((a . 1) (b . two))"
  [ds indent]
  (let [key-length (->> ds (map (comp count name key)) (apply max))]
    (->> ds
         (map-indexed (fn [i [k v]]
                        (let [key-name (name k)]
                          (str (if (zero? i) "" (str "\n " (spaces indent)))
                               "("
                               (right-pad key-length key-name)
                               " . "
                               (convert-value v (+ indent key-length 5))
                               ")"))))
         (str/join " ")
         (#(str "(" % ")")))))

(if-let [[filename] *command-line-args*]
  (let [data (read-string (slurp filename))]
    (println (convert-map data 0)))
  (println "Usage: edn2scm.bb <file.edn>"))
