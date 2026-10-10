(local {: some} (require "nfnl.core"))

(local default-socket "~/.local/run/guile.socket")

;; Устанавливает несколько параметров для текущего буфера.
(fn vim-b [options]
  (each [_ option (ipairs options)]
    (let [[k v] option]
      (tset vim.b k v))))

;; Функция ожидает, пока результат выполнения `check-fn` не станет истиной. В случае
;; успеха - вызывает `on-success`. Если же число попыток превышено - вызывает `on-error`.
(fn wait-for-something
  [check-fn on-success on-error attempts delay]
  (if (= attempts 0) (on-error)
      (if (check-fn) (on-success)
          (vim.fn.timer_start delay (fn []
                                      (wait-for-something check-fn on-success on-error (- attempts 1) delay))))))

;; Функция ждет появления сокета для поключения к Guile. В случае успеха - вызвает
;; команду Conjure для подключения.
(fn wait-for-socket
  [socket-path]
  (wait-for-something
    (fn [] (= (vim.fn.getftype (vim.fn.expand socket-path)) "socket"))
    (fn [] (vim.cmd "ConjureConnect"))
    (fn []
      (vim.notify "Guile socket was not created." vim.log.levels.ERROR))
    10
    500))

;; Запускает guile в окне терминала, после чего возвращается в исходный буфер.
(fn guile-run
  [guile-command socket]
  (let [source-win (vim.api.nvim_get_current_win)
        terminal-buf (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_open_win terminal-buf true {:split "below" :win source-win})
    (vim.fn.termopen [guile-command socket])
    (vim.api.nvim_set_current_win source-win)))

;; Подключается к сокету guile, запуская guile при необходимости.
(fn guile-connect
  [guile-command socket-path]
  (let [socket (vim.fn.expand socket-path)]
    ;; Настраиваем тип подключения и путь к сокету для Conjure.
    (vim-b [["conjure#filetype#scheme" "conjure.client.guile.socket"]
            ["conjure#client#guile#socket#pipename" socket]])

    ;; Если сокет уже существует, пропускаем запуск guile.
    (when (not= (vim.fn.getftype socket) "socket")
      (vim.fn.mkdir (vim.fn.fnamemodify socket ":h") "p")
      (guile-run guile-command socket))

    (wait-for-socket socket)))


(let [ext (vim.fn.expand "%:e")]
  (if
    ;; Guile
    (= ext "scm")
    (vim.api.nvim_buf_create_user_command
      0 "GuileConnect"
      (fn [_]
        (vim.ui.input
          {:prompt "Guile socket: "
           :default (or (. vim.b "conjure#client#guile#socket#pipename") default-socket)
           :completion "file"}
          (fn [path]
            (when (and path (not= path ""))
              (guile-connect "guile-repl" path)))))
      {})
  
    ;; Chez
    (= ext "ss")
    (vim-b [["conjure#client#scheme#stdio#command" "petite"]
            ["conjure#client#scheme#stdio#prompt_pattern" "> $?"]
            ["conjure#client#scheme#stdio#value_prefix_pattern" false]])))

