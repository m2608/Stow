(local core (require "nfnl.core"))

(let [filetypes ["clojure" "fennel" "janet" "hy" "scheme" "lua" "lisp" "python" "janet" "joker"]]
  {1 "Olical/conjure"
   :ft filetypes
   :init
   (fn []
     (tset vim.g "conjure#filetypes" filetypes))
   :config
   (fn []
     (let [options [["conjure#mapping#prefix" ","]
                    ;; Показываем документацию по prefix+k, на ["K"] (без префикса)
                    ;; уже показывает документацию lsp-сервер. А короткую сигнатуру
                    ;; показывает он же по space+k, если что.
                    ["conjure#mapping#doc_word" "k"]
                    ;; Настройки для Chez Scheme.
                    ["conjure#client#scheme#stdio#command" "petite"]
                    ["conjure#client#scheme#stdio#prompt_pattern" "> $?"]
                    ["conjure#client#scheme#stdio#value_prefix_pattern" false]
                    ;; joker
                    ["conjure#filetype#joker" "conjure.client.joker.stdio"]
                    ;; Настройки для Python.
                    ["conjure#client#python#stdio#command" "python3 -iq"]]]
       (each [_ option (ipairs options)]
         (let [[k v] option]
           (tset vim.g k v)))))})
