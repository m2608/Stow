#!/usr/bin/env bb
;; Based on https://github.com/babashka/babashka/blob/master/examples/image_viewer.clj

(ns show-requests
  (:require [babashka.fs :as fs]
            [babashka.process :refer [process]]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [org.httpkit.server :as server]
            [cheshire.core :as json])
  (:import [java.time LocalDateTime]
           [java.time.format DateTimeFormatter]))

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

(def csp (str/join " " (map #(str % " *;")
                            ["default-src" "script-src" "img-src" "font-src" "style-src" "object-src" "media-src" "frame-src"])))

(defn now
  []
  (let [date (LocalDateTime/now)]
    (.format date (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss"))))

(defn text-to-image [text]
  @(process
    {:in text :out :bytes}
    "convert"
    "-background" "black"
    "-fill" "#03A062"
    "-font" "White-Rabbit"
    "-pointsize" "24"
    "text:-"
    "-trim"
    "+repage"
    "-bordercolor" "black"
    "-border" "10x10"
    "PNG:-"))

(server/run-server
  (fn [{:keys [uri remote-addr request-method headers]
        request-body :body
        :or {request-body nil}}]
    (let [origin (-> (filter (fn [h] (= (first h) "origin")) headers) first second)
          now (now)
          request-text (str "--> " now " [" remote-addr "]\n" (str/upper-case (name request-method)) " " uri "\n"
                            (str/join "\n" (map (fn [h] (str (first h) ": " (second h))) headers)) "\n"
                            (if request-body (str "\n" (slurp request-body) "\n") ""))
          request-json (json/generate-string
                         {:time now
                          :method (str/upper-case (name request-method))
                          :uri uri
                          :remote-addr remote-addr
                          :headers headers
                          :body (if request-body (str "\n" (slurp request-body) "\n") nil)}
                         {:pretty true})]
      (println request-text)
      (cond
        (str/starts-with? uri "/!png/")
        {:headers {"Content-Type" "image/png"
                   "Content-Security-Policty" csp}
         :body (-> (text-to-image request-json) :out)}

        :else
        {:headers {"Content-Type" "application/json"
                   "Content-Security-Policy" csp}
         :body request-json})))
  {:port port :ip bind})

(println "Starting http server at" (str bind ":" port))

@(promise)
