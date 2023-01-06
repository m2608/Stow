#!/usr/bin/env -S NODE_PATH=${HOME}/.local/lib/node_modules nbb

(ns nbb-tw
  "Веб-сервер для сохранения TiddlyWiki."
  (:require [clojure.string :as str]
            ["express$default" :as express]
            ["argparse" :as argparse :refer [ArgumentParser]]
            ["fs" :as fs]
            ["path" :as path]
            ["child_process" :as cp]))

(defn file-exists
  "Проверяет, существует ли файл. Если нет, выбрасывает исключение."
  [filename]
  (try
    (.accessSync fs filename)
    (catch js/Error _
      (throw (js/Error. (str "File does not exists: " filename))))))

(defn file-save
  "Сохраняет файл. Если сохранить не удалось, выбрасывает исключение."
  [filename data]
  (try
    (.writeFileSync fs filename data)
    (catch js/Error _
      (throw (js/Error. (str "Could not save file: " filename))))))

(defn commit-changes
  "Коммитит в fossil-репозиторий изменения. В случае ошибки выбрасывает исключение."
  []
  (try
    (.spawnSync cp "fossil" (clj->js ["addremove"]))
    (.spawnSync cp "fossil" (clj->js ["commit" "--no-warnings" "-m" "Autocommit"]))
    (catch js/Error _
      (throw (js/Error. (str "Could not commit to repository."))))))

;; Парсер аргументов командной строки.
(def parser (ArgumentParser #js {:prog "nbb-tw.cljs"
                                 :description "HTTP server for saving TiddlyWiki."}))

(.add_argument parser "-b" "--bind" #js {:help "ip address to bind" :default "127.0.0.1"})
(.add_argument parser "-p" "--port" #js {:help "port to listen" :default 8008})
(.add_argument parser "-c" "--commit" #js {:help "commit changes to fossil" :action "store_true"})

(def args (.parse_args parser (clj->js (vec *command-line-args*))))

(def bind (.-bind args))
(def port (.-port args))
(def commit (.-commit args))
(def app (express))

;; Настраиваем раздачу статики.
(.use app
      (.static express
               ;; Раздаем из текущего каталога.
               (.cwd js/process)
               ;; Запрещаем кешировать файлы, чтобы не было проблем при одновременном
               ;; открытии вики из разных браузеров (иначе может сохраниться старая
               ;; закешированная версия).
               (clj->js {:setHeaders
                         (fn [res _ _]
                           (.set res "Cache-Control" "no-store, must-revalidate"))})))

;; Сохраняем тело запроса в req.body.
(.use app
      (fn [req _ next-chunk]
        (let [body (atom [])]
          ;; Читаем чанки и конвертируем их в строки.
          (.on req "data" #(swap! body conj (.toString %)))
          ;; Объединяем чанки и сохраняем результат в body.req.
          (.on req "end" #(do (set! (.-body req) (str/join @body))
                              (next-chunk))))))

;; Обрабатываем запросы от TiddlyWiki.
(.use app
      (fn [req res next]
        (case (.-method req)
          ;; TiddlyWiki узнает возможности сервера с помощью OPTIONS запроса. Здесь
          ;; нужно сообщить вики о возможности сохранения изменений с помощью PUT запроса.
          "OPTIONS"
          (let [headers {:allow "GET,HEAD,OPTIONS,PUT"
                         :x-api-access-type "file"
                         :dav "tw5/put"}]
            (doseq [h headers]
              (.set res (name (key h)) (val h)))
            (.send res ""))
          ;; Сохранение TiddlyWiki.
          "PUT"
          (let [file-path (.join path (.cwd js/process) (.-path req))
                file-data (.-body req)]
            (try
              ;; Сохраняем файл.
              (file-save file-path file-data)
              (println "File saved:" file-path)
              ;; Если указано, что нужно коммитить изменения в базу, пытаемся это сделать.
              (when commit
                (commit-changes)
                (println "Changes commited to repository"))
              ;; Если ошибок не было, возвращаем пустой ответ со статусом 200.
              (.send res "")
              (catch js/Error e
                ;; Если возникли ошибки, возвращаем ошибку со статусом 500.
                (do (println (.-message e))
                    (.status res 500)
                    (.send res (.-message e))))))
          (next))))

(def server (.listen app port bind
                     (fn []
                       (println "Root directory:" (.cwd js/process))
                       (println "Commit changes:" (if commit "yes" "no"))
                       (println "Server running on port" port))))

(comment
  (.close server))
