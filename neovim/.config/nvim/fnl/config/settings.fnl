(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local str  (autoload "nfnl.str"))

(fn file-exists? [filename]
  "Проверяет, существует ли файл."
  (let [file (io.open filename)
        exists (~= file nil)]
    (when exists
      (io.close file))
    exists))

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
               ;; отключаем мышь
               [:mouse ""]
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
               [:wrap true]
               ;; включаем плавную прокрутку перенесенных строк
               [:smoothscroll true]
               ;; выключаем сворачивание кода
               [:foldenable false]
               ;; показывать только меню при автодополнении (не показывать окно предпросмотра)
               [:completeopt "menu"]]]
  (each [_ option (ipairs options)]
    (let [name (. option 1)
          value (. option 2)]
      (core.assoc vim.o name value))))

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
       "autocmd BufNewFile conjure-log-* lua vim.diagnostic.enable(false)"
       ;; отключаем сворачивание для файлов hurl
       "autocmd Syntax hurl setlocal foldmethod=manual"]]
  (each [_ cmd (ipairs commands)]
    (vim.cmd cmd)))


;; Хак для определения фона терминала в tmux.
; (when (= (os.getenv "TERM") "tmux-256color")
;   (vim.uv.fs_write 2 "\27Ptmux;\27\27]11;?\7\27\\" -1 nil))

(if
  (= (os.getenv "COOL_RETRO_TERM") "1")
  ;; Для Cool Retro Term выбираем какую-нибудь простую схему и устанавливаем
  ;; режим 16 цветов. Чтобы это работало, нужно при запуске CRT установить
  ;; переменную COOL_RETRO_TERM=1.
  (let [ffi (require "ffi")]
    (ffi.cdef "int t_colors")
    (core.assoc ffi.C :t_colors 16)
    (vim.cmd.colorscheme "illyria"))

  ;; Настройка цветовой схемы в соответствие со схемой терминала.
  (let [colorscheme-filename (.. (os.getenv "HOME") "/.vimrc_background")]
    (when (file-exists? colorscheme-filename)
      ; (core.assoc nvim.g :base16colorspace 256)
      (vim.cmd (.. "source" colorscheme-filename)))))

;; Настройка диагностических сообщений:
;; * отключаем отображение сообщений в строках со сработками,
;; * оставляем показ меток на строках со сработками,
;; * включаем показ всплывающего окна при переходе к строке со сработкой.
(vim.diagnostic.config
  {:virtual_text false
   :signs true
   :float {:source "always" :border "single"}})
