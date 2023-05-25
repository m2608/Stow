#!/usr/bin/env bb
#_" -*- mode: clojure; -*-"
;; Based on https://github.com/babashka/babashka/blob/master/examples/image_viewer.clj

(ns http-server
  (:require [babashka.fs :as fs]
            [clojure.java.browse :as browse]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [org.httpkit.server :as server]
            [hiccup2.core :as html]
            [cheshire.core :as json])
  (:import [java.net URLDecoder URLEncoder]
           [java.time LocalDateTime]
           [java.time.format DateTimeFormatter]
           ))

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

(assert (fs/directory? dir) (str "The given dir `" dir "` is not a directory."))

(def csp (str "default-src *  data: blob: filesystem: about: ws: wss: 'unsafe-inline' 'unsafe-eval' 'unsafe-dynamic'; "
              "script-src * data: blob: 'unsafe-inline' 'unsafe-eval'; "
              "connect-src * data: blob: 'unsafe-inline'; "
              "img-src * data: blob: 'unsafe-inline'; "
              "frame-src * data: blob: ; "
              "style-src * data: blob: 'unsafe-inline';"
              "font-src * data: blob: 'unsafe-inline';"
              "frame-ancestors * data: blob: 'unsafe-inline';"))

(defn now
  []
  (let [date (LocalDateTime/now)]
    (.format date (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss"))))

(server/run-server
  (fn [{:keys [uri remote-addr request-method headers]
        request-body :body
        :or {request-body nil}}]
    (let [origin (-> (filter (fn [h] (= (first h) "origin")) headers) first second)
          request-text (str "--> " (now) " [" remote-addr "]\n" (str/upper-case (name request-method)) " " uri "\n"
                            (str/join "\n" (map (fn [h] (str (first h) ": " (second h))) headers)) "\n"
                            (if request-body (str "\n" (slurp request-body) "\n") ""))
          request-json (json/generate-string
                         {:method (str/upper-case (name request-method))
                          :remote-addr remote-addr
                          :headers headers
                          :body (if request-body (str "\n" (slurp request-body) "\n") nil)})]
      (println request-text)
      {:headers {"Content-Type" "application/json"
                 "Content-Security-Policy" csp
                 ;"Access-Control-Allow-Origin" (or origin "*")
                 ;"Access-Control-Allow-Methods" "POST, GET"}
                 }
       :body request-json}))
  {:port port :ip bind})

(println "Starting http server at" (str bind ":" port))

@(promise)
