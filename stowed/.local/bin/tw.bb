#!/usr/bin/env bb

(ns tw
  (:require [babashka.fs :as fs]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.java.io :as io]
            [org.httpkit.server :as server]
            [hiccup2.core :as html])
  (:import [java.net URLDecoder URLEncoder]))

(def cli-options
  [["-p" "--port PORT" "Port for HTTP server" :default 8000 :parse-fn #(Integer/parseInt %)]
   ["-b" "--bind IP" "IP to bind to" :default "127.0.0.1"]
   ["-d" "--dir DIR" "Directory to serve files from" :default "."]
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
(def dir (-> (:dir opts) fs/path fs/absolutize fs/normalize))

(def mime-types 
  {"html" "text/html"
   "jpg" "image/jpeg"
   "png" "image/png"})

(assert (fs/directory? dir) (str "The given dir `" dir "` is not a directory."))

(defn index [path]
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
                   child (when (fs/directory? (fs/path dir child)) "/")]])]
          [:hr]
          [:footer {:style {"text-align" "center"}} "Served by http-server.clj"]]]
        html/html
        str)))

(defn get-absolute-path
  [uri]
  (->> (str/replace-first (URLDecoder/decode uri) #"^/" "")
       (fs/path dir)
       fs/absolutize
       fs/normalize))

(defn handle-get
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
  [uri]
  (dissoc (handle-get uri) :body))

(defn handle-options
  []
  {:headers {"allow" "GET,OPTIONS,PUT"
             "x-api-access-type" "file"
             "dav" "tw5/put"}})

(defn handle-put [uri data]
  (let [path (get-absolute-path uri)]
    (if (not (fs/starts-with? path dir))

      {:status 403 :body "Permission denied"}

      (do (io/copy data (fs/file path))
          {:status 200}))))

(server/run-server
  (fn [{:keys [uri remote-addr request-method body]
        :or {body nil}}]
    (println (format "[%s] %s %s" remote-addr (-> request-method name str/upper-case) uri))
    (case request-method
      :get     (handle-get uri)
      :head    (handle-head uri)
      :options (handle-options)
      :put     (handle-put uri body)
      
      {:status 403 :body "Method not allowed"}))
  {:port port :ip bind})

(println (format "Starting http server at %s:%d\nServing files at: %s"
                 bind port dir))

@(promise)
