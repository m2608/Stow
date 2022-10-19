(module plugins
  {autoload {nvim aniseed.nvim
             core aniseed.core
             packer packer}})

(defn load-plugins [plugins]
  "Загружает плагины из списка"
  (packer.startup
    (fn [use]
      (each [_ plugin (ipairs plugins)]
        (let [value-type (type plugin)]
          (use (if
                 ;; Если передана строка, просто загружаем плагин по его названию.
                 (= value-type "string")
                 plugin
                 ;; Если передана таблица, формируем аргумент для функции загрузки:
                 ;; элемент с ключом "1" - название плагина;
                 ;; остальные элементы берем из таблицы опций.
                 (= value-type "table")
                 (let [name (. plugin 1)
                       opts (. plugin 2)]
                   (core.assoc opts 1 name)))))))))
 
(load-plugins
  [
   ;; плагин для удобного изменения тегов, кавычек
   "tpope/vim-surround"
   ;; выравнивание текста по разделителю
   "godlygeek/tabular"
   ;; lsp
   "neovim/nvim-lspconfig"
   ;; навигация по файлам
   "kyazdani42/nvim-tree.lua"
   ;; fuzzy search
   ["nvim-telescope/telescope.nvim"
    {:branch "0.1.x"
     :requires ["nvim-lua/plenary.nvim"]}]
   ;; комментирование кода
   "tomtom/tcomment_vim"
   ;; навигация по коду
   "preservim/tagbar"
   ;; универсальный REPL через tmux
   "jpalardy/vim-slime"
   ;; работа с Clojure REPL
   "Olical/conjure"
   ;; запуск Clojure REPL в терминале vim
   ["clojure-vim/vim-jack-in"
    {:requires ["tpope/vim-dispatch"
                "radenling/vim-dispatch-neovim"]}]
   ;; радужные скобки
   "kien/rainbow_parentheses.vim"
   ;; подсветка синтаксиса Fennel
   "bakpakin/fennel.vim"
   ;; подсветка для hurl
   "fourjay/vim-hurl"
   ;; работа с git
   "tpope/vim-fugitive"
   ;; асинхронный запуск команд
   "skywind3000/asyncrun.vim"
   ;; копирование в буфер через ANSI OSC52 последовательность
   "ojroques/vim-oscyank"
   ;; запуск neovim в firefox
   ["glacambre/firenvim"
    {:run (fn [] ((. nvim.fn "firenvim#install")))}]
   ])

(core.assoc nvim.g "tagbar_ctags_bin" "/usr/local/bin/uctags")

(core.assoc nvim.g "conjure#mapping#prefix" ",")

;; Настройки Conjure для fennel (используем aniseed).
(core.assoc nvim.g "conjure#client#fennel#aniseed#aniseed_module_prefix" "aniseed.")

;; Настройки Conjure для chez-scheme.
(core.assoc nvim.g "conjure#client#scheme#stdio#command" "petite")
(core.assoc nvim.g "conjure#client#scheme#stdio#prompt_pattern" "> $?")
(core.assoc nvim.g "conjure#client#scheme#stdio#value_prefix_pattern" false)

(let [nvim-tree (require "nvim-tree")]
  ((. nvim-tree "setup")
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
       :folder_arrow false}}}}))

;; используем tmux для vim-slime
(core.assoc nvim.g "slime_target" "tmux")
(core.assoc nvim.g "slime_paste_file" "$HOME/.slime_paste")
;; по умолчанию текст будет отправляться в последнюю панель текущего окна
;; это удобно, когда окно tmux разделено на два, и в одном запущен REPL
(core.assoc nvim.g "slime_default_config" 
      {:socket_name "default"
       :target_pane "{last}"})
;; при первой отправке slime не будет запрашивать настройки, а будет
;; использовать заданные по умолчанию, их всегда можно изменить в
;; помощью :SlimeConfig
(core.assoc nvim.g "slime_dont_ask_default" 1)

(core.assoc nvim.g "firenvim_config"
            {:globalSettings
             {:alt "all"}
             :localSettings
             {".*"
              {:cmdline "neovim"
               :content "text"
               :priority 0
               :selector "textarea"
               :takeover "never"}}})
