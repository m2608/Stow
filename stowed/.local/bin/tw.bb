#!/usr/bin/env bb

(ns tw
  (:require [babashka.fs :as fs]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.java.io :as io]
            [org.httpkit.server :as server]
            [hiccup2.core :as html])
  (:import [java.net URI URLEncoder]
           [java.time LocalDateTime]
           [java.time.format DateTimeFormatter]))

(def cli-options
  [["-p" "--port PORT" "Port for HTTP server" :default 8000 :parse-fn #(Integer/parseInt %)]
   ["-b" "--bind IP" "IP to bind to" :default "127.0.0.1"]
   ["-d" "--dir DIR" "Directory to serve files from" :default "."]
   ["" "--backup DIR" "Save backups to this folder"]
   ["-h" "--help" "Print usage info"]])

(def parsed-args
  (parse-opts *command-line-args* cli-options))

(def opts
  (:options parsed-args))

(cond
  (:help opts)
  (do (println "Web server for TiddlyWiki. Usage:\n" (:summary parsed-args))
      (System/exit 0))

  (:errors parsed-args)
  (do (println "Invalid arguments:\n" (str/join "\n" (:errors parsed-args)))
      (System/exit 1))

  :else
  :continue)


(def port (:port opts))
(def bind (:bind opts))
(def dir (fs/canonicalize (:dir opts)))
(def bak (:backup opts))

(when (not (fs/directory? dir))
  (println (format "The given dir \"%s\" is not a directory." dir))
  (System/exit 1))

(def mime-types
  {"html" "text/html"
   "jpg" "image/jpeg"
   "png" "image/png"})

(defn now
  "Возвращает текущее время."
  []
  (.format (LocalDateTime/now)
           (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss")))

(defn index
  "Возвращает индекс указанного каталога."
  [path]
  (let [files (map #(str (.relativize dir %))
                   (fs/list-dir path))
        rel-path (fs/relativize dir path)]
    (-> [:html
         [:head
          [:meta {:charset "UTF-8"}]
          [:title (str "Index of /" rel-path)]]
         [:body
          [:h1 "Index of /" rel-path]
          [:ul
           (for [child files]
             [:li [:a {:href (URLEncoder/encode (str child))}
                   child (when (fs/directory? (fs/path dir child)) "/")]])]]]
        html/html
        str)))

(defn get-absolute-path
  "Возвращает путь к файлу по запрошенному URI."
  [uri]
  (let [uri-path (.getPath (URI. uri))]
    (->> (str/replace-first uri-path #"^[/]" "")
         (fs/path dir)
         (fs/canonicalize))))

(defn save-backup
  [filename]
  (when (and bak (fs/directory? bak))
    (let [[n ext] (fs/split-ext (fs/file-name filename))
          newname (fs/path bak (str n "." (now) "." ext))]
      (println (now) (format "Backing up %s to %s" filename newname))
      (fs/copy filename newname))))

(defn handle-get
  "Обработка GET-запросов."
  [uri]
  (let [path (get-absolute-path uri)]
    (cond
      (not (fs/starts-with? path dir))
      {:status 403 :body "Permission denied"}

      (fs/directory? path)
      {:body (index path)}

      (fs/readable? path)
      {:headers {"Content-Type" (get mime-types (fs/extension path) "text/plain")}
       :body (fs/file path)}

      :else
      {:status 404 :body (str "File not found: " (fs/relativize dir path))})))

(defn handle-head
  "Обработка HEAD запросов."
  [uri]
  (dissoc (handle-get uri) :body))

(defn handle-options
  "Обработка OPTIONS. Этот ответ взят из других примеров, поддерживающих
  TiddlyWiki, вероятно, эти заголовки нужны для корректной работы."
  []
  {:headers {"allow" "GET,OPTIONS,PUT"
             "x-api-access-type" "file"
             "dav" "tw5/put"}})

(defn handle-put
  "Обработка PUT - запись файла на диск."
  [uri data]
  (let [path (get-absolute-path uri)]
    (if (not (fs/starts-with? path dir))

      {:status 403 :body "Permission denied"}

      (do (save-backup path)
          (io/copy data (fs/file path))
          {:status 200}))))

(try
  (server/run-server
    (fn [{:keys [uri remote-addr request-method body]
          :or {body nil}}]
      (println (format "%s [%s] %s %s" (now) remote-addr (-> request-method name str/upper-case) uri))
      (case request-method
        :get     (handle-get uri)
        :head    (handle-head uri)
        :options (handle-options)
        :put     (handle-put uri body)

        {:status 403 :body "Method not allowed"}))
    {:port port :ip bind})
  (catch java.net.BindException _
    (println (format "Address already in use: %s:%d" bind port))
    (System/exit 1)))

(println (format "Starting http server at %s:%d\nServing files at: %s"
                 bind port dir))
(when bak
  (println "Backup folder:" bak))

@(promise)
