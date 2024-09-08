(module settings
  {autoload
    {core :aniseed.core
     str :aniseed.string
     nvim :aniseed.nvim}})

(fn file-exists? [filename]
  "Проверяет, существует ли файл."
  (let [file (io.open filename)
        exists (~= file nil)]
    (when exists
      (io.close file))
    exists))

(fn get-resource [name]
  "Получает значение параметра Xresources."
  ;; Старые версии xrdb не поддерживают получение значения параметра по его имени:
  ;; `xrdb -get st.foreground`. Поэтому приходится сначала получать весь список с
  ;; помощью `xrdb -query`.
  (let [h (io.popen "xrdb -query")]
    (when h
      (let [data (h:read "*a")]
        (h:close)
        (->> (str.split data "\n")
             (core.map (fn [line] (str.split line "\t")))
             (core.filter (fn [[n _]] (= n (.. name ":"))))
             core.first
             core.second)))))

(fn get-resource-color-components [name]
  "Получает компоненты цвета, заданного в параметре Xresources."
  (let [value (get-resource name)]
    (when value
      (core.map (fn [x] (tonumber x 16))
                (str.split (core.first (str.split (core.second (str.split value ":"))
                                                  "\n"))
                           "/")))))

(fn sum [numbers]
  "Суммирует числа."
  (core.reduce (fn [a b] (+ a b)) 0 numbers))

; (fn pipe-visual []
;   (let [buffer (vim.api.nvim_get_current_buf)
;         [sl sc el ec] (unpack (vim.api.nvim_buf_get_mark buffer "<>"))]
;     [sl sc el ec]))

; function VisualToUpper()
;     -- Get the current buffer and selection range
;     local bufnr = vim.api.nvim_get_current_buf()
;     local start_line, start_col, end_line, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '<>'))
;
;     -- Get the selected lines
;     local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
;
;     -- Convert the selected lines to uppercase
;     local uppercase_lines = {}
;     for _, line in ipairs(lines) do
;         table.insert(uppercase_lines, string.upper(line))
;     end
;
;     -- Replace the selected lines with the uppercase lines
;     vim.api.nvim_buf_set_text(bufnr, start_line - 1, start_col - 1, end_line, end_col, uppercase_lines)
; end

(let [;; маппинги для использования команд, если включена русская системная раскладка
      lang-mappings ["ё`" "йq" "цw" "уe" "кr" "еt" "нy" "гu" "шi" "щo" "зp" "х[" "ъ]" "фa" "ыs" "вd"
                     "аf" "пg" "рh" "оj" "лk" "дl" "ж;" "э'" "яz" "чx" "сc" "мv" "иb" "тn" "ьm" "б,"
                     "ю." "Ё~" "ЙQ" "ЦW" "УE" "КR" "ЕT" "НY" "ГU" "ШI" "ЩO" "ЗP" "Х{" "Ъ}" "ФA" "ЫS"
                     "ВD" "АF" "ПG" "РH" "ОJ" "ЛK" "ДL" "Ж:" "Э\"" "ЯZ" "ЧX" "СC" "МV" "ИB" "ТN" "ЬM"
                     "Б<" "Ю>"]
      ;; Последовательность задания опций может быть важна, так что используем массив, а не хешмэп, при обходе
      ;; которого последовательность не гарантируется. Например, если установить опцию "iminsert" перед "keymap",
      ;; при установке "keymap", значение "iminsert" будет переопределено.
      options [;; поддержка true color
               [:termguicolors true]
               ;; размер табуляции - 4 пробела
               [:tabstop 4]
               ;; заменять табуляции пробелами для всех файлов, кроме Makefile
               [:expandtab true]
               ;; количество пробелов для автовыравнивания кода
               [:shiftwidth 4]
               ;; показывать относительные номера строк
               [:relativenumber true]
               ;; показывать номер текущей строки
               [:number true]
               ;; показывать колонку с метками (иначе она будет показываться только когда
               ;; есть метки, например, предупреждения или ошибки)
               [:signcolumn "yes"]
               ;; вертикальный сплит открывает окно справа
               [:splitright true]
               ;; горизонтальный split открывает окно снизу
               [:splitbelow true]
               ;; добавить русскую раскладку (переключение по ctrl+^)
               [:keymap "russian-jcukenwin2"]
               ;; при запуске vim по умолчанию будем все-таки использовать стандартный keymap (английский)
               ;; и для вставки, и для поиска
               [:iminsert 0]
               [:imsearch 0]
               ;; задаем маппинги для использования команд, если включена русская системная раскладка
               ;; код ниже экранирует специальные символы и объединяет все в строку
               [:langmap (table.concat
                           (core.map
                             (fn [m] (core.reduce
                                       (fn [m escaped-char]
                                         (string.gsub m escaped-char (.. "\\" escaped-char)))
                                       m
                                       ["\\" "\"" "|" "," ";"]))
                             lang-mappings)
                           ",")]
               [:ignorecase true]
               [:smartcase true]
               ;; отключаем перенос длинных строк
               [:wrap false]
               ;; выключаем сворачивание кода
               [:foldenable false]
               ;; показывать только меню при автодополнении (не показывать окно предпросмотра)
               [:completeopt "menu"]
               ;; команда :find будет искать файлы также и в подкаталогах
               [:path (.. (core.get nvim.o "path") "**")]
               ;; шрифт для графического режима
               [:guifont "Iosevka Term:h16"]]]
  (each [_ option (ipairs options)]
    (let [name (. option 1)
          value (. option 2)]
      (core.assoc nvim.o name value))))

;; для отрытия каталогов в telescope file browser
(core.assoc nvim.g :loaded_netrw 1)

(let [commands
      [;; заменять табуляции пробелами для всех файлов, кроме Makefile
       "autocmd FileType make setlocal noexpandtab"
       ;; отступы для javascript
       "autocmd FileType javascript setlocal ts=3 sts=3 sw=3"
       ;; отступы для vue
       "autocmd FileType vue setlocal ts=2 sts=2 sw=2"
       ;; файлы babashka
       "autocmd BufRead,BufNewFile *.bb set filetype=clojure"
       ;; закрываем скратч-буфер, который открывается для omnicompletion
       "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif"
       "autocmd InsertLeave * if pumvisible() == 0|pclose|endif"
       ;; бирюзовый курсор при включенной русской раскладке
       "highlight lCursor guifg=NONE guibg=Cyan cterm=none ctermfg=none ctermbg=214"
       ;; language of messages
       "language en_US.UTF-8"
       ;; показываем диагностическое сообщение при задержке курсора на строке
       ;; "autocmd CursorHold * lua vim.diagnostic.open_float()"
       ;; отключаем линтер для REPL Conjure (баг в nvim https://github.com/Olical/conjure/pull/420)
       "autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)"
       ;; отключаем сворачивание для файлов hurl
       "autocmd Syntax hurl setlocal foldmethod=manual"]]
  (each [_ cmd (ipairs commands)]
    (nvim.command cmd)))


(if
  (= (os.getenv "COOL_RETRO_TERM") "1")
  ;; Для Cool Retro Term выбираем какую-нибудь простую схему и устанавливаем
  ;; режим 16 цветов. Чтобы это работало, нужно при запуске CRT установить
  ;; переменную COOL_RETRO_TERM=1.
  (let [ffi (require "ffi")]
    (ffi.cdef "int t_colors")
    (core.assoc ffi.C :t_colors 16)
    (vim.cmd.colorscheme "illyria"))

  ;; Цветовая схема для nvim-gtk.
  (core.get nvim.g :GtkGuiLoaded nil)
  (vim.cmd.colorscheme "nano-theme")

  ;; Настройка цветовой схемы в соответствие со схемой терминала.
  ;; Определяем цвета терминала из Xresources. В зависимости от значений
  ;; фона и основного цвета устанавливаем тёмную или светлую цветовую тему.
  (let [fg (sum (get-resource-color-components "st.foreground"))
        bg (sum (get-resource-color-components "st.background"))
        colorscheme-filename (.. (os.getenv "HOME") "/.vimrc_background")]

    (if (< bg fg)
      (core.assoc nvim.o :background "dark")
      (core.assoc nvim.o :background "light"))

    (when (file-exists? colorscheme-filename)
      ; (core.assoc nvim.g :base16colorspace 256)
      (nvim.command (.. "source" colorscheme-filename)))))


;; Настройка диагностических сообщений:
;; * отключаем отображение сообщений в строках со сработками,
;; * оставляем показ меток на строках со сработками,
;; * включаем показ всплывающего окна при переходе к строке со сработкой.
(vim.diagnostic.config
  {:virtual_text false
   :signs true
   :float {:source "always" :border "single"}})

;; Настройки nvim-gtk.
(when (core.get nvim.g :GtkGuiLoaded nil)
  (let [hostname (vim.fn.hostname)
        gui-options [["Font" (if
                               (= hostname "algol")
                               "PragmataPro Liga 16"
                               (string.find hostname "usd[-]mazonix1")
                               "Iosevka 14"
                               "")]
                     ["Option" "Popupmenu" 1]
                     ["Option" "Tabline" 1]
                     ["Option" "Cmdline" 1]]]
    (each [_ option (ipairs gui-options)]
      (vim.rpcnotify 1 "Gui" (unpack option)))))


;; На рабочем компе меняем путь к python.
(when (string.find (nvim.fn.hostname) "usd[-]mazonix1")
  (core.assoc nvim.g :python3_host_prog (.. (nvim.fn.getenv "HOME") "/.local/bin/python3.11")))
