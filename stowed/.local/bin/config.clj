#!/usr/bin/env bb

(require '[clojure.string :as str])

(when (empty? *command-line-args*)
  (let [program (last (str/split (System/getProperty "babashka.file") #"/"))]
    (println (str "Usage: " program " <command> <file> <section> <name> [<value> [value]]

Commands:

get    - get value from a file
set    - set value in a file
toggle - toggle between two values
parse  - show config as json
"))
    (System/exit 0)))
  
(defn parse-section
  [line]
  (when (and (str/starts-with? line "[") (str/ends-with? line "]"))
    (subs line 1 (dec (count line)))))

(defn parse-kv
  [line]
  (when-let [eq-char (str/index-of line "=")]
    [(str/trim (subs line 0 eq-char))
     (str/trim (subs line (inc eq-char)))]))

(def comment-chars ["#" ";"])

(defn comment?
  [line]
  (some (fn [c]
          (str/starts-with? line c))
        comment-chars))

(defn parse-line
  [[sections cur-s] line]
  (if-let [new-s (parse-section line)]
    [(assoc sections new-s (get sections new-s {})) new-s]
    (let [[k v :as kv] (parse-kv line)]
      (if (and cur-s kv)
        [(update sections cur-s #(assoc % k v)) cur-s]
        [sections cur-s]))))

(defn read-ini
  [filename]
  (->> (slurp filename)
       (str/split-lines)
       (map str/trim)
       (filter (complement comment?))
       (reduce parse-line [{} nil])
       first))

(defn write-ini
  [filename data]
  (->> data
       (map (fn [[s kvs]]
              (format "[%s]\n%s\n"
                      s
                      (->> kvs
                           (map (fn [[k v]]
                                  (format "%s=%s" k v)))
                           (str/join "\n")))))
       (str/join "\n")
       (spit filename)))

;; Функционал кода ниже такой же, однако он не меняет форматирование файла. Значения
;; меняются в той строке, где они найдены, комментарии и пустые строки не удаляются.
;; Также не возникнет ошибки, если формат файла неверный (например, есть пары
;; ключ-значение, не входящие ни в какие секции).
                              
; (defn parse-k
;   [line]
;   (when-let [[k _] (parse-kv line)]
;     k))
;
; (defn get-value
;   [filename section key]
;   (loop [lines (str/split-lines (slurp filename))
;          current-section nil]
;     (if (empty? lines) nil
;       (if-let [s (parse-section (first lines))]
;         (recur (rest lines) s)
;         (if-let [[k v] (parse-kv (first lines))]
;           (if (and (= section current-section) (= k key)) v
;             (recur (rest lines) current-section))
;           (recur (rest lines) current-section))))))
;
; (defn set-value
;   [filename section key value]
;   (->>
;     (loop [head-lines [] tail-lines (str/split-lines (slurp filename))
;            current-section nil]
;       (cond
;         (and (empty? tail-lines) (not= current-section section))
;         (conj head-lines (format "[%s]\n%s=%s" section key value))
;
;         (empty? tail-lines)
;         (conj head-lines (format "%s=%s" key value))
;
;         (and (= current-section section) (parse-section (first tail-lines)))
;         (concat head-lines [(format "%s=%s" key value)] tail-lines)
;
;         (and (= current-section section) (= key (parse-k (first tail-lines))))
;         (concat head-lines [(format "%s=%s" key value)] (rest tail-lines))
;
;         :else
;         (recur (conj head-lines (first tail-lines)) (rest tail-lines)
;                (or (parse-section (first tail-lines)) current-section))))
;     (str/join "\n")
;     (format "%s\n")
;     (spit filename)))
; (let [[command filename section key value other-value] *command-line-args*]
;   (case command
;     "get"
;     (if-let [v (get-value filename section key)]
;       (println v)
;       (System/exit 1))
;
;     "set"
;     (set-value filename section key value)
;
;     "toggle"
;     (let [v (get-value filename section key)]
;       (set-value filename section key (if (and v (= v value)) other-value value)))
;
;     (do (println "Unknown command:" command)
;         (System/exit 1))))


(let [[command filename section key value other-value] *command-line-args*]
  (case command
    "get"
    (if-let [v (get-in (read-ini filename) [section key])]
      (println v)
      (System/exit 1))
    
    "set"
    (write-ini filename (assoc-in (read-ini filename) [section key] value))
    
    "toggle"
    (let [v (get-in (read-ini filename) [section key])]
      (write-ini filename (assoc-in (read-ini filename) [section key]
                                    (if (and v (= v value)) other-value value))))

    "parse"
    (println (json/generate-string (read-ini filename)))
    
    (do (println "Unknown command:" command)
        (System/exit 1))))

