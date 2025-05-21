#!/usr/bin/env bb

;; Рерайт этого алгоритма:
;; https://github.com/omgovich/omgopass

(require '[clojure.string :as str]
         '[clojure.math :as math]
         '[clojure.tools.cli :refer [parse-opts]])
(import '[java.security SecureRandom])

(def cli-options
  [["-n" "--syllables-count COUNT" "Number of syllables to produce"
    :default 3
    :parse-fn #(Integer/parseInt %)
    :validate [pos? "must be positive"]]
   [nil "--min LENGTH" "Minimum syllable length"
    :id :min-syllable-length
    :default 6
    :parse-fn #(Integer/parseInt %)
    :validate [#(>= % 2) "must be 2 at least"]]
   [nil "--max LENGTH" "Maximum syllable length"
    :id :max-syllable-length
    :default 7
    :parse-fn #(Integer/parseInt %)
    :validate [#(>= % 2) "must be 2 at least"]]
   ["-d" "--[no-]digit" "Add digit to each syllable"
    :default true]
   ["-u" "--[no-]uppercase" "Randomly uppercase some letters"
    :default false]
   ["-s" "--separators CHARS" "Symbols used to join syllables"
    :default "-"]
   ["-v" "--vowels CHARS" "Vowels list"
    :default "aeiouy"
    :validate [#(pos? (count %)) "at least one vowel needed"]]
   ["-c" "--consonants CHARS" "Consonants list"
    :default "bcdfghjklmnpqrstvwxz"
    :validate [#(pos? (count %)) "at least one consonant needed"]]
   ["-p" "--print-entropy" "Print entropy for current options set"
    :default false]
   ["-h" "--help" "Print this help"]])

;; Initialize secure random generator.
(def random (SecureRandom.))

(defn rand-int
  "Возвращает случайное целое в диапазоне [a, b). Если указан только один
  аргумент, вернёт целое в диапазоне [0, b)."
  ([b]
   (rand-int 0 b))
  ([a b]
   (+ a (.nextInt random (- b a)))))

(defn rand-choice
  "Выбирает случайный элемент из коллекции."
  [xs]
  (nth xs (rand-int (count xs))))

(defn get-complexity
  "Возвращает примерную энтропию пароля."
  [& {:keys [syllables-count min-syllable-length digit uppercase separators vowels consonants]}]
  (let [groups [[(count vowels)     (* syllables-count (quot min-syllable-length       2))]
                [(count consonants) (* syllables-count (quot (inc min-syllable-length) 2))]
                [(count separators) (dec syllables-count)]
                [10 (if digit syllables-count 0)]
                [2 (if uppercase (* syllables-count min-syllable-length) 0)]]]
    (int (/ (math/log (reduce (fn [acc [chars number]]
                                (* acc (if (zero? chars) 1 (math/pow chars number)))) 1 groups))
            (math/log 2)))))

(defn generate
  "Генерирует пароль в соответствии с аргументами."
  [& {:keys [syllables-count min-syllable-length max-syllable-length digit uppercase separators vowels consonants]
      :or {syllables-count 3
           min-syllable-length 6
           max-syllable-length 7
           digit true
           uppercase false
           separators "-"
           vowels "aeiouy"
           consonants "bcdfghjklmnpqrstvwxz"}}]
  (let [maybe-add-number
        (if digit
          (fn [syllable]
            (conj syllable (rand-int 10)))
          identity)

        maybe-uppercase
        (if uppercase
          (fn [syllable]
            (apply str (map #(if (pos? (rand-int 2)) (str/upper-case %) %) syllable)))
          identity)

        maybe-add-separator
        (if (pos? (count separators))
          (fn [n syllable]
            (if (pos? n)
              (vec (cons (rand-choice separators) syllable))
              syllable))
          (fn [_ syllable] syllable))]
    (->> (map (fn [n]
                (->> (let [length (rand-int min-syllable-length (inc max-syllable-length))]
                       (mapv (fn [i]
                               (rand-choice (if (even? i) consonants vowels)))
                             (range length)))
                     maybe-add-number
                     maybe-uppercase
                     ((partial maybe-add-separator n))
                     (apply str)))
              (range syllables-count))
         (apply str)
         println)))

(let [parsed-args (parse-opts *command-line-args* cli-options)
      opts (:options parsed-args)]
  (cond
    (:help opts)
    (do (println (format "Generates random password. Usage:\n%s" (:summary parsed-args)))
        (System/exit 0))

    (:errors parsed-args)
    (do (println (format "Invalid arguments:\n%s" (str/join "\n" (:errors parsed-args))))
        (System/exit 1))

    (:print-entropy opts)
    (println "Min entropy:" (get-complexity opts))

    :else
    (generate opts)))
