(local {: autoload} (require "nfnl.module"))
(local core (require "nfnl.core"))
(local str (require "nfnl.string"))

; Функция прогоняет список строк через пайп указанной команды.
(fn pipe-lines
  [command lines]
  (let [process (vim.system ["sh" "-c" command] {:text true :stdin (table.concat lines "\n")})]
    (str.split (core.get (process:wait) :stdout) "\n")))

; Функция берет выделенные строки прогоняет через пайп.
(fn pipe-visual-lines
  [command]
  (let [[sl _] (vim.api.nvim_buf_get_mark 0 "<")
        [el _] (vim.api.nvim_buf_get_mark 0 ">")
        lines (vim.api.nvim_buf_get_lines 0 (- sl 1) el true)]
    (vim.api.nvim_buf_set_lines 0 (- sl 1) el true (pipe-lines command lines))))

; Функция берет выделение (не строки целиком и прогоняет через пайп).
(fn pipe-visual
  [command]
  (let [[sl sc] (vim.api.nvim_buf_get_mark 0 "<")
        [el ec] (vim.api.nvim_buf_get_mark 0 ">")
        lines (vim.api.nvim_buf_get_lines 0 (- sl 1) el true)
        pref (string.sub (core.first lines) 1 sc)
        post (string.sub (core.last lines) (+ 2 ec))]
    (core.update lines (core.count lines)
                 (fn [line] (string.sub line 1 (+ 1 ec))))
    (core.update lines 1
                 (fn [line] (string.sub line (+ 1 sc))))
    (let [new-lines (pipe-lines command lines)]
      (core.update new-lines 1
                   (fn [line] (.. pref line)))
      (core.update new-lines (core.count new-lines)
                   (fn [line] (.. line post)))
      (vim.api.nvim_buf_set_lines 0 (- sl 1) el true new-lines))))

(fn pipe [command]
  (let [mode (vim.fn.visualmode)]
    (if
      (= mode "v") (pipe-visual command)
      (= mode "V") (pipe-visual-lines command))))

(vim.api.nvim_create_user_command "Pipe" (fn [opts] (pipe opts.args))
                                  {:range true :nargs 1})

; Спрашиваем команду у пользователя и используем её для модификации выделения.
; (vim.keymap.set "v" "|" (fn [opts]
;                           (let [mode (vim.fn.visualmode)]
;                             (when (core.some (fn [m] (= m mode)) ["v" "v"])
;                               (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes "<Esc>" true false true) "n" true)
;                               (let [command (vim.fn.input "| ")]
;                                 (when (not= command "")
;                                   (pipe command))))))
;                           {:silent false :desc "Pipe visual selection through shell command"})

(vim.keymap.set "v" "|" ":Pipe " {:silent false :desc "Pipe visual selection through shell command"})
