#!/usr/bin/env bb
#_" -*- mode: clojure; -*-"
;; Based on https://github.com/babashka/babashka/blob/master/examples/image_viewer.clj

(ns http-server
  (:require [babashka.fs :as fs]
            [clojure.java.browse :as browse]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
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
  (do (println "Start a http server and show requests. Usage:\n" (:summary parsed-args))
      (System/exit 0))
  
  (:errors parsed-args)
  (do (println "Invalid arguments:\n" (str/join "\n" (:errors parsed-args)))
      (System/exit 1))
  
  :else
  :continue)


(def port (:port opts))
(def bind (:bind opts))
(def dir (fs/path (:dir opts)))

(def mime-types 
  {"html" "text/html"
   "jpg" "image/jpeg"
   "js" "text/javascript"
   "png" "image/png"})

(assert (fs/directory? dir) (str "The given dir `" dir "` is not a directory."))

(defn index [f]
  (let [files (map #(str (.relativize dir %)) 
                   (fs/list-dir f))]
    (-> [:html
         [:head
          [:meta {:charset "UTF-8"}]
          [:title (str "Index of `" f "`")]]
         [:body
          [:h1 "Index of " [:code (str f)]]
          [:ul
           (for [child files]
             [:li [:a {:href (URLEncoder/encode (str child))} child (when (fs/directory? (fs/path dir child)) "/")]])]
          [:hr]
          [:footer {:style {"text-align" "center"}} "Served by http-server.clj"]]]
        html/html
        str)))

(defn body [path]
  (fs/file path))

(server/run-server
  (fn [{:keys [uri remote-addr request-method headers]
        request-body :body
        :or {request-body nil}}]
    (println (str "[" remote-addr "] "
                  (str/upper-case (name request-method)) " " uri "\n"
                  (str/join "\n" (map (fn [h] (str (first h) ": " (second h)))
                                      headers))
                  "\n"
                  (if request-body (str "\n" (slurp request-body) "\n") "")))
    (let [f (fs/path dir (str/replace-first (URLDecoder/decode uri) #"^/" ""))
          origin (-> (filter (fn [h] (= (first h) "origin")) headers) first second)
          index-file (fs/path f "index.html")]
      (cond
        (not (fs/starts-with? (-> f fs/absolutize fs/normalize)
                              (-> dir fs/absolutize fs/normalize)))
        {:status 403 :body "Permission denied"}

        (and (fs/directory? f) (fs/readable? index-file))
        {:body (body index-file)}

        (fs/directory? f)
        {:headers {"Access-Control-Allow-Origin" (or origin "*")
                   "Access-Control-Allow-Methods" "POST, GET"}
         :body (index f)}

        (fs/readable? f)
        {:headers {"Content-Type" (get mime-types (fs/extension f) "text/plain")}
         :body (body f)}

        :else
        {:status 404 :body (str "File not found: " f)}))
    
    )
  {:port port :ip bind})

(println "Starting http server at" (str bind ":" port))

@(promise)
