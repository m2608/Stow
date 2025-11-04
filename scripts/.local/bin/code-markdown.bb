#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[clojure.tools.cli :refer [parse-opts]]
         '[babashka.fs :as fs])

(def cli-options
  [["-l" "--lang LANGUAGE" "Source code language"]
   ["-p" "--prefix PREFIX" "Comment prefix (regular expression)"]
   ["-h" "--help"          "Print usage info"]])

(defn usage [summary]
  (str "Converts source code file to markdown.

- Comments with predefined prefix rendered as regular markdown text.
- Code goes to code blocks.

Usage: code-markdown [options] [file]

Options:

" summary "\n"))

;; Определяем символы комментариев для различных языков.
(def language->prefix
  {"scheme"  ";;[ ]?"
   "clojure" ";;[ ]?"
   "python"  "#[ ]?"})

;; Мапа для определения языка по расширению.
(def extension->language
  {"scm" "scheme"
   "clj" "clojure"
   "py"  "python"})

(defn code->code-block
  [lines language]
  (str "```" language "\n" (str/join "\n" lines) "```\n"))

(defn comment->markdown
  [lines prefix]
  (->> lines
       (map #(str/replace-first % prefix ""))
       (str/join "\n")))

(defn convert
  "Вариант 1 - partition + map. 
  Не очень нравится, как здесь проверяется тип группы (комментарий или код)."
  [data language prefix]
  (let [prefix-regexp (re-pattern (str "^" prefix))
        comment? (fn [line] (re-find prefix-regexp line))]
    (->> (str/split-lines data)
         ;; Разбиваем на группы строк: комментарии и блоки кода.
         (partition-by comment?)
         ;; В зависимости от типы группы преобразуем строки.
         (map (fn [lines]
                (if (comment? (first lines))
                  (comment->markdown lines prefix-regexp)
                  (code->code-block lines language))))
         (str/join "\n"))))

(defn check-help
  "Если указан ключ помощи, выводит инструкции по использованию и выбрасывает исключение."
  [parsed-opts]
  (when (-> parsed-opts :options :help)
    (throw (ex-info (usage (:summary parsed-opts)) {:exit-code 0})))
  parsed-opts)

(defn check-args
  "Если произошли ошибки при парсинге аргументов, выбрасывает исключение с соответствующим
  сообщением."
  [parsed-opts]
  (when-let [errors (:errors parsed-opts)]
    (throw (ex-info (str "Invalid arguments:\n" (str/join "\n" errors)) {:exit-code 1})))
  parsed-opts)

(defn process-file
  "Преобразует код из файла в markdown."
  [{prefix :prefix lang :lang} file]

  (let [file-ext (fs/extension file)
        lang (or lang (extension->language file-ext))
        prefix (or prefix (language->prefix lang))]

    (when-not (fs/exists? file)
      (throw (ex-info (str "File does not exist: " file) {:exit-code 3})))

    (when-not lang
      (throw (ex-info (str "Could not derive language for file extension: " file-ext) {:exit-code 2})))
      
    (when-not prefix
      (throw (ex-info (str "Could not derive comment prefix for specified language: " lang) {:exit-code 2})))
        
    (convert (slurp file) lang prefix)))

(defn process-stdin
  "Преобразует код из потока ввода в markdown."
  [{prefix :prefix lang :lang}]

  (let [prefix (or prefix (language->prefix lang))]

    (when-not lang
      (throw (ex-info "Should specify language for stdin processing." {:exit-code 2})))

    (when-not prefix
      (throw (ex-info (str "Could not derive comment prefix for specified language: " lang) {:exit-code 2})))

    (convert (slurp *in*) lang prefix)))

(defn process-code
  "В зависимости от аргументов либо обрабатывает файл, либо поток ввода."
  [parsed-opts]
  (let [options (:options parsed-opts)]
    (let [[file] (:arguments parsed-opts)]
      (if file
        (process-file options file)
        (process-stdin options)))))

(try
  (-> *command-line-args* (parse-opts cli-options) check-help check-args process-code println)
  (catch Exception e
    (println (ex-message e))
    (System/exit (:exit-code (ex-data e)))))

