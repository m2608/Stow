#!/usr/bin/env bb

(require '[babashka.fs :as fs]
         '[babashka.process :as p]
         '[clojure.string :as str])

(import '[java.net UnixDomainSocketAddress StandardProtocolFamily]
        '[java.nio.channels Channels ServerSocketChannel]
        '[java.nio.file Files]
        '[java.io BufferedReader InputStreamReader]
        '[java.util Base64])

(def socket-path
  (UnixDomainSocketAddress/of
    (fs/path (System/getenv "HOME") ".local/run/clipboard.sock")))

(defn base64-encode
  "Преобразует строку в Base64."
  [s]
  (.encodeToString (Base64/getEncoder) (.getBytes s "UTF-8")))

(defn osc52 [s]
  (format "\033]52;c;%s\007" (base64-encode s)))

(defn osc52-copy!
  [s]
  (print (osc52 s))
  (flush))

(defn tmux-copy! [s]
  (deref (p/process ["tmux" "load-buffer" "-w" "-"] {:in s})))

(defn xclip-copy! [s]
  (deref (p/process ["xclip" "-selection" "clipboard"] {:in s})))

;; Открываем UNIX сокет, слушаем его. А когда приходят данные -
;; копируем их в буфер обмена с помощью `xclip`.
;;
;; По сути это аналог команды:
;;
;; socat UNIX-LISTEN:"$HOME/.local/run/clipboard.sock",fork EXEC:'xclip -selection clipboard'

(let [path (.getPath socket-path)]
  (Files/deleteIfExists path)
  (try
    (with-open [server (ServerSocketChannel/open StandardProtocolFamily/UNIX)]
      (.bind server socket-path)
      (println "Listening on" (.toString socket-path))

      (while true
        (with-open [client (.accept server)
                    reader (-> client
                               Channels/newInputStream
                               InputStreamReader.
                               BufferedReader.)]

          (println "Client connected.")
          (let [text (slurp reader)]
            (println "Data received:" (count text) "chars.")
            (xclip-copy! text)))))
    (finally
      (Files/deleteIfExists path))))
