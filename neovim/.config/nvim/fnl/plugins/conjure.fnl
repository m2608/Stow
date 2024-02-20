(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "Olical/conjure"
 :config (fn []
           (let [options [["conjure#mapping#prefix" ","]
                          ;; Показываем документацию по prefix+k, на ["K"] (без префикса)
                          ;; уже показывает документацию lsp-сервер. А короткую сигнатуру
                          ;; показывает он же по space+k, если что.
                          ["conjure#mapping#doc_word" "k"]
                          ;; Настройки для Chez Scheme.
                          ["conjure#client#scheme#stdio#command" "petite"]
                          ["conjure#client#scheme#stdio#prompt_pattern" "> $?"]
                          ["conjure#client#scheme#stdio#value_prefix_pattern" false]
                          ;; Настройки для Python.
                          ["conjure#client#python#stdio#command" "python3 -iq"]]]
                 (each [_ option (ipairs options)]
                   (core.assoc nvim.g (unpack option)))))}
