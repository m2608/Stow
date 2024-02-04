(local {: autoload} (require "nfnl.module"))
(local nvim (autoload "nvim"))

(fn pipe-visual []
  ;(vim.api.nvim_input "<ESC>")
  (let [buf (vim.api.nvim_get_current_buf)
        [sl sc] (vim.api.nvim_buf_get_mark buf "<")
        [el ec] (vim.api.nvim_buf_get_mark buf ">")
        lines (vim.api.nvim_buf_get_text buf (- sl 1) sc (- el 1) (+ ec 1) {})]
    (print sl sc el ec (vim.inspect lines))))

(fn f1 [x]
  (print x))

(nvim.command (.. "command! -range -nargs=1 -complete=shellcmd Pipe "
                  "call luaeval('require(\"config/myfunctions\")[\"f1\"](<f-args>)')"))

;(vim.keymap.set "v" "|" pipe-visual {:silent false :desc "pipe visual selection to command."})

; (vim.keymap.set "v" "|" pipe-visual {:silent false :desc "pipe visual selection to command."})


; function visualtoupper()
;     -- get the current buffer and selection range
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

{: f1 : pipe-visual}
