(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

(fn file-exists? [filename]
  "Проверяет, существует ли файл. Возвращает имя файла или nil."
  (let [file (io.open filename)
        exists (~= file nil)]
    (when exists
      (io.close file))
    (if exists filename nil)))

{1 "preservim/tagbar"
 :config
 (fn []
   (core.assoc nvim.g "tagbar_ctags_bin"
               (or (file-exists? "/usr/local/bin/uctags")
                   (file-exists? "/usr/bin/ctags"))))}
