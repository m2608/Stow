(def os-package-command
  {:alpine  ["apk" "add"]
   :android ["pkg" "install" "-y"]
   :debian  ["apt" "install" "-y"]
   :freebsd ["pkg" "install" "-y"]
   :rhel    ["dnf" "install" "-y"]
   :void    ["xbps-install" "-y"]})

(defn shell
  "Выполняет переданную команду с аргументами, возвращает stdout."
  [& args]

  # использование (with ...) позволяет автоматически закрыть пайпы процесса

  # :p - будет выполнен поиск программы в PATH
  # :x - если программа вернёт ненулевой статус, генерируем ошибку

  (with [proc (os/spawn args :xp {:out :pipe})]

    # запускаем параллельно fibers для ожидания и чтения

    (let [[out] (ev/gather
                  (ev/read (proc :out) :all)
                  (os/proc-wait proc))]
      (string/trimr (or out "")))))

(defn parse-os-release []
  "Парсит /etc/os-release, возвращает мапу (точнее - struct)."
  (let [path "/etc/os-release"]
    (if (os/stat path)
      (->> (slurp path)
           (peg/match
             ~(any (sequence
                     (<- (some (if-not "=" 1)))
                     "="
                     (<- (some (if-not "\n" 1)))
                     "\n")))
           (apply struct))
      {})))

(defn get-os-name
  "Возвращает имя операционной системы. 
  Сначала проверяет значение `uname -o`. Если команда возвращает GNU/Linux, 
  имя операционной системы берётся из файла /etc/os-release."
  []
  (let [uname-os (shell "uname" "-o")]
    (if (= uname-os "GNU/Linux")
      (let [os-release (parse-os-release)]
        (or (os-release "NAME") ""))
      uname-os)))

(defn get-os-id
  "Возвращает идентификатор операционной системы в виде кейворда."
  []
  (let [uname-os (shell "uname" "-o")]
    (if (= uname-os "GNU/Linux")
      (let [os-id ((parse-os-release) "ID")]
        (if os-id (keyword os-id)))
      (keyword (string/ascii-lower uname-os)))))

# Default
#
# - устанавливаем программу с помощью пакетного менеджера, имя соответствует ключу конфига
# - если значение - keyword, используем метод, соответствующий ключевому слову
# - если значение - мапа, смотрим ключи мапы
#     - ключ :default соответствует поведению по умолчанию
#     - остальные ключи соответствуют названиям операционных систем
#         - если значение ключа - keyword, переопределяем метод установки
#         - если значение ключа - строка, переопределяем имя пакета
#         - если значение ключа - мапа, переопределяем имя пакета и метод, в зависимости от ключей
#             - :name   - для переопределения имени
#             - :method - для переопределения метода установки

# (type :keyword) # :keyword
# (type "string") # :string
# (type {})       # :struct

(defn get-install-rules
  [packages-filename]
  (let [osid (get-os-id)
        arch (os/arch)
        packages (parse (slurp packages-filename))]
    packages))

(get-install-rules "packages.edn")
