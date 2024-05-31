#!/usr/bin/env bb

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
           [java.time.format DateTimeFormatter]))

(def cli-options
  [["-p" "--port PORT" "Port for HTTP server" :default 8000 :parse-fn #(Integer/parseInt %)]
   ["-b" "--bind IP" "IP to bind to" :default "127.0.0.1"]
   ["-u" "--user USERNAME" "Username" :default "admin"]
   ["-p" "--pass PASSWORD" "Password" :default "admin"]
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
(def user (:user opts))
(def pass (:pass opts))

(defn now
  []
  (let [date (LocalDateTime/now)]
    (.format date (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss"))))

(defn base64-decode [s]
  (String. (.decode (java.util.Base64/getDecoder) s)))

(defn get-user-pass [headers]
  (some-> (get headers "authorization")
          (str/split #" " 2)
          peek
          base64-decode
          (str/split #":" 2)))

(server/run-server
  (fn [{:keys [remote-addr headers]}]
    (let [[u p] (get-user-pass headers)]
      (println "-->" (now) "[" remote-addr "]\nUsername:" u "\nPassword:" p "\n")
      (if (and (= u user) (= p pass))
        {:status 200
         :body "You are in!"}
        {:status 401
         :headers {"WWW-Authenticate" "Basic realm=\"Enter password:\""}
         :body ""})))
  {:port port :ip bind})

(println "Starting http server at" (str bind ":" port))

@(promise)
