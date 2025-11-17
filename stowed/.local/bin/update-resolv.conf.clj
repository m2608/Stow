#!/bin/env bb

;; Скрипт для автоматического обновления системного списка DNS (/etc/resolv.conf) при подключении
;; и отключении к VPN (с помощью OpenVPN).

;; Параметры для клиентского конфига OpenVPN. Разрешаем выполнение скриптов и указываем
;; наш скрип в качестве up и down скрипта.
;;
;;     script-security 2
;;     up /home/undume/update-resolv.conf.clj
;;     down /home/undume/update-resolv.conf.clj

(require '[clojure.string :as string])
(require '[babashka.process :refer [shell]])

;; Утилита для добавления DNS серверов в системный список.
(def *resolv-conf* "resolvconf")

;; Стандартные пути для поиска местонахождения утилиты (OpenVPN выполняет up и down скрипты
;; с пустым PATH.
(def *path* "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin")

(defn parse-option
  "Парсит опции, связанные с настройкой dhcp."
  [option]
  (let [[name type value] (string/split option #" ")]
    (when (= name "dhcp-option")
      (cond
        (nat-int? (.indexOf ["DNS"] type))
        (str "nameserver " value)
        (nat-int? (.indexOf ["DOMAIN" "DOMAIN-SEARCH"] type))
        (str "search " value)
        true nil))))

(defn add-dns
  "Добавляет DNS-серверы в системный список."
  [dev env]
  (let [opts (->> env
                  ;; Опции передаются утилите в виде переменных среды, имена которых
                  ;; начинаются с указанной подстроки.
                  (filter (fn [[k v]] (string/starts-with? k "foreign_option_")))
                  (map second)
                  (map parse-option)
                  (remove nil?))]
    (when (seq opts)
      (shell {:in (string/join "\n" opts)
              :extra-env {"PATH" *path*}
              :err :string}
             *resolv-conf* "-x" "-a" dev))))

(defn del-dns
  "Удаляем DNS-серверы из системного списка."
  [dev env]
  (shell {:extra-env {"PATH" *path*}
          :err :string}
         *resolv-conf* "-d" dev))

(let [env (into {} (System/getenv))
      dev (str (env "dev") ".inet")]
  ;; Тип скрипта передается через переменную среды.
  (case (env "script_type")
    "up" (add-dns dev env)
    "down" (del-dns dev env)))
