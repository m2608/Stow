(module plugins
        {autoload {nvim aniseed.nvim
                   core aniseed.core}})

(defn load-plugins [plugins]
  "Загружает плагины из списка"
  (->
    (icollect [_ plugin (ipairs plugins)]
      (let [value-type (type plugin)]
        (if
          ;; Если передана строка, просто загружаем плагин по его названию.
          (= value-type "string")
          plugin
          ;; Если передана таблица, формируем аргумент для функции загрузки:
          ;; элемент с ключом "1" - название плагина;
          ;; остальные элементы берем из таблицы опций.
          (= value-type "table")
          (let [name (. plugin 1)
                opts (. plugin 2)]
            (core.assoc opts 1 name)))))
    ((. (require "lazy") :setup))))

(load-plugins
  [
   ;; Плагин для менеджмента плагинов.
   ["folke/lazy.nvim" {:version "*"}]
   ;; Интеграция fennel.
   "Olical/aniseed"
   ;; плагин для удобного изменения тегов, кавычек
   ["tpope/vim-surround"
    {:dependencies ["tpope/vim-repeat"]}]
   ;; Работа с s-выражениями.
   ["guns/vim-sexp"
    {:dependencies ["tpope/vim-repeat"]}]
   ;; Маппинги для vim-sexp.
   ["tpope/vim-sexp-mappings-for-regular-people"
    {:dependencies ["guns/vim-sexp" "tpope/vim-repeat" "tpope/vim-surround"]}]
   ;; выравнивание текста по разделителю
   "godlygeek/tabular"
   ;; lsp
   "neovim/nvim-lspconfig"
   ;; treesitter
   ["nvim-treesitter/nvim-treesitter"
    {:cond
     ;; Проверяем наличие компилятора и tree-sitter.
    (and (= 1 (nvim.fn.executable "clang"))
         (= 1 (nvim.fn.executable "tree-sitter")))

    :build
    (fn []
      (let [ts-install (require "nvim-treesitter.install")]
        ((. ts-install "update") {:with_sync true})))

    :main "nvim-treesitter.configs"

    :config
    (fn []
      ;; настройка treesitter, для автоматической компиляции нужно установить tree-sitter-cli
      ;; gcc в CentOS очень старые, есть проблемы с компиляцией некоторых парсеров, поэтому
      ;; будем использовать clang
      (let [ts-install (require "nvim-treesitter.install")
            ts-configs (require "nvim-treesitter.configs")]
        (tset ts-install :compilers ["clang"])

        ((. ts-configs "setup")
         {:ensure_installed
          ["c"
           "clojure"
           "commonlisp"
           "cpp"
           "css"
           "diff"
           "dockerfile"
           "dot"
           "fennel"
           "fish"
           "html"
           "ini"
           "javascript"
           "jq"
           "json"
           "lua"
           "make"
           "markdown"
           "python"
           "scheme"
           "sql"
           "toml"
           "typescript"
           "vim"
           "vue"
           "yaml"]
          :highlight {:enable true}
          :indent {:enable true}})))}]
   ;; навигация по файлам
   "kyazdani42/nvim-tree.lua"
   ;; fuzzy search
   ["nvim-telescope/telescope.nvim"
    {:branch "0.1.x"
     :dependencies ["nvim-lua/plenary.nvim"]}]
   ;; дерево undo
   "mbbill/undotree"
   ;; комментирование кода
   "tomtom/tcomment_vim"
   ;; навигация по коду
   "preservim/tagbar"
   ;; универсальный REPL через tmux
   "jpalardy/vim-slime"
   ;; универсальный REPL внутри nvim
   "hkupty/iron.nvim"
   ;; работа с Clojure REPL
   "Olical/conjure"
   ["clojure-vim/vim-jack-in"
    {:dependencies ["tpope/vim-dispatch" "radenling/vim-dispatch-neovim"]}]
   ;; документация по clojure
   ["kkharji/lispdocs.nvim"
    {:dependencies ["kkharji/sqlite.lua"]}]
   ;; подсветка синтаксиса Fennel
   "bakpakin/fennel.vim"
   ;; подсветка для hurl
   "fourjay/vim-hurl"
   ;; подсветка для vue
   "posva/vim-vue"
   ;; работа с git
   "tpope/vim-fugitive"
   ;; асинхронный запуск команд
   "skywind3000/asyncrun.vim"
   ;; копирование в буфер через ANSI OSC52 последовательность
   "ojroques/vim-oscyank"
   ;; запуск neovim в firefox
   ["glacambre/firenvim"
    {:lazy false
     :build (fn []
              ((. nvim.fn "firenvim#install") 0))
     :config (fn []
               (core.assoc nvim.g "firenvim_config"
                           {:globalSettings
                            {:alt "all"}
                            :localSettings
                            {".*"
                             {:cmdline "neovim"
                              :content "text"
                              :priority 0
                              :selector "textarea"
                              :takeover "never"}}}))
     }]
   "bounceme/restclient.vim"
   ;; режим шестнадцатиричного редактора
   "RaafatTurki/hex.nvim"
   ;; хелп по хоткеям
   "folke/which-key.nvim"
   ])

(core.assoc nvim.g "tagbar_ctags_bin" "/usr/local/bin/uctags")

(core.assoc nvim.g "conjure#mapping#prefix" ",")
;; Показываем документацию по prefix+k, на ["K"] (без префикса)
;; уже показывает документацию lsp-сервер. А короткую сигнатуру
;; показывает он же по space+k, если что.
(core.assoc nvim.g "conjure#mapping#doc_word" "k")

;; Настройки для Chez Scheme.
(core.assoc nvim.g "conjure#client#scheme#stdio#command" "petite")
(core.assoc nvim.g "conjure#client#scheme#stdio#prompt_pattern" "> $?")
(core.assoc nvim.g "conjure#client#scheme#stdio#value_prefix_pattern" false)

;; Настройки для Clojure.
; (core.assoc nvim.g "conjure#client#clojure#nrepl#eval#auto_require" false)
; (core.assoc nvim.g "conjure#client#clojure#nrepl#connection#auto_repl#enabled" false)

(core.assoc nvim.g "sexp_enable_insert_mode_mappings" false)

((. (require "nvim-tree") "setup")
 ;; Будем открывать дерево в каталоге текущего файла.
 {:update_focused_file
  {:enable true
   :update_cwd true}
  :renderer
  {:icons
   {:show
    {:git false
     :folder true
     :file false
     :folder_arrow false}}}})

((. (require "telescope") "setup")
 {:defaults {:preview {:check_mime_type false}
             :mappings {:n {"d" (. (require "telescope.actions") "delete_buffer")}}}})

;; используем tmux для vim-slime
(core.assoc nvim.g "slime_target" "tmux")
; (core.assoc nvim.g "slime_paste_file" "$HOME/.slime_paste")
;; по умолчанию текст будет отправляться в последнюю панель текущего окна
;; это удобно, когда окно tmux разделено на два, и в одном запущен REPL
(core.assoc nvim.g "slime_default_config" 
      {:socket_name "default"
       :target_pane "{last}"})
;; при первой отправке slime не будет запрашивать настройки, а будет
;; использовать заданные по умолчанию, их всегда можно изменить в
;; помощью :SlimeConfig
(core.assoc nvim.g "slime_dont_ask_default" 1)

;; настройка iron, универсального repl'а
((. (require "iron.core") "setup")
 {:config
  {:scratch_repl true
   :repl_definition
   {:sh
    {:command ["sh"]}
    :python
    {:command ["python3"]}
    :cljs
    {:command ["nbb" "nrepl-server"]}}
   :repl_open_cmd
   ((. (require "iron.view") "bottom") 20)}
  :keymaps
  {:send_motion "<space>sc"
   :visual_send "<space>sc"
   :send_file "<space>sf"
   :send_line "<space>sl"
   :send_mark "<space>sm"
   :mark_motion "<space>mc"
   :mark_visual "<space>mc"
   :remove_mark "<space>md"
   :cr "<space>s<cr>"
   :interrupt "<space>s<space>"
   :exit "<space>sq"
   :clear "<space>cl"}})

; настройка firenvim
; (core.assoc nvim.g "firenvim_config"
;             {:globalSettings
;              {:alt "all"}
;              :localSettings
;              {".*"
;               {:cmdline "neovim"
;                :content "text"
;                :priority 0
;                :selector "textarea"
;                :takeover "never"}}})


;; инициализируем плагин hex для автоматического отрытия двоичных файлов
;; в hex-редакторе (не включаю по-умолчанию, т.к. функционал плохо работает
;; на файлах с 8-бинтыми кодировками (cp866, cp1251 etc)
;; ((. (require "hex") "setup"))

;; настройки плагина, показывающего хоткеи
((. (require "which-key") "setup")
                {})

;; необходимо для which-keys
(core.assoc nvim.o :timeout true)
(core.assoc nvim.o :timeoutlen 300)

