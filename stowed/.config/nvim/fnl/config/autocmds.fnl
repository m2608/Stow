(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local str (autoload "nfnl.string"))

(local augroup vim.api.nvim_create_augroup)
(local autocmd vim.api.nvim_create_autocmd)

;; Установка формата для файлов *.bqn.
(autocmd
  ["BufRead" "BufNewFile"]
  {:pattern "*.bqn"
   :command "setf bqn"})

;; Настройка комментариев для hurl.
(augroup "hurl" {:clear true})
(autocmd
  ["BufNewFile" "BufRead"]
  {:pattern "*.hurl"
   :group "hurl"
   :callback (fn [args]
               (vim.cmd "setlocal commentstring=#\\ %s")
               (vim.keymap.set "n" "<F5>" ":OutSplit hurl<CR>" {:silent true}))})

;; Маппинги символов BQN для файлов соответствующего типа.
(autocmd
  ["FileType"]
  {:pattern "bqn"
   :callback (fn [event]
               (let [prefix "\\"
                     mappings [["`" "˜"] ["1" "˘"] ["2" "¨"] ["3" "⁼"] ["4" "⌜"] ["5" "´"] ["6" "˝"] ["7" "7"]
                               ["8" "∞"] ["9" "¯"] ["0" "•"] ["-" "÷"] ["=" "×"] ["~" "¬"] ["!" "⎉"] ["@" "⚇"]
                               ["#" "⍟"] ["$" "◶"] ["%" "⊘"] ["^" "⎊"] ["&" "⍎"] ["*" "⍕"] ["(" "⟨"] [")" "⟩"]
                               ["_" "√"] ["+" "⋆"] ["q" "⌽"] ["w" "𝕨"] ["e" "∊"] ["r" "↑"] ["t" "∧"] ["y" "y"]
                               ["u" "⊔"] ["i" "⊏"] ["o" "⊐"] ["p" "π"] ["[" "←"] ["]" "→"] ["Q" "↙"] ["W" "𝕎"]
                               ["E" "⍷"] ["R" "𝕣"] ["T" "⍋"] ["Y" "Y"] ["U" "U"] ["I" "⊑"] ["O" "⊒"] ["P" "⍳"]
                               ["{" "⊣"] ["}" "⊢"] ["a" "⍉"] ["s" "𝕤"] ["d" "↕"] ["f" "𝕗"] ["g" "𝕘"] ["h" "⊸"]
                               ["j" "∘"] ["k" "○"] ["l" "⟜"] [";" "⋄"] ["'" "↩"] ["\\" "\\"] ["A" "↖"] ["S" "𝕊"]
                               ["D" "D"] ["F" "𝔽"] ["G" "𝔾"] ["H" "«"] ["J" "J"] ["K" "⌾"] ["L" "»"] [":" "·"]
                               ["\"" "˙"] ["|" "|"] ["z" "⥊"] ["x" "𝕩"] ["c" "↓"] ["v" "∨"] ["b" "⌊"] ["n" "n"]
                               ["m" "≡"] ["," "∾"] ["." "≍"] ["/" "≠"] ["Z" "⋈"] ["X" "𝕏"] ["C" "C"] ["V" "⍒"]
                               ["B" "⌈"] ["N" "N"] ["M" "≢"] ["<" "≤"] [">" "≥"] ["?" "⇐"] ["<space>" "‿"]]]
                     (each [_ [m k] (ipairs mappings)]
                       (vim.keymap.set "i" (.. prefix m) k {:buffer event.buf}))))})

(augroup "markdown-conceal" {:clear true})
(autocmd
  "Filetype"
  {:group "markdown-conceal"
   :pattern "markdown"
   :callback (fn []
               (set vim.opt_local.conceallevel 0))})

;; автокоманда нужна для патчинга цветового выделения, когда используются цвета
;; терминала
(augroup "colorscheme-patch" {:clear true})
(autocmd
  "ColorScheme"
  {:group "colorscheme-patch"
   :pattern "default"
   :callback (fn []
               (when (not (core.get vim.o "termguicolors"))
                 (vim.api.nvim_set_hl 0 "Visual" {:ctermfg 0 :ctermbg 7})))})

;; группа для прозрачного шифрования файлов ключами ssh с помощью утилиты "age"
(augroup "age-encryption" {:clear true})

;; при открытии зашифрованных файлов нужно отключить все временные файлы, которые
;; потенциально могут хранить расшифрованное содержимое
(autocmd
  ["BufReadPre" "FileReadPre" "BufNewFile"]
  {:group "age-encryption"
   :pattern "*.age"
   :callback (fn []
               (let [options {:swapfile false
                              :undofile false
                              :backup false
                              :writebackup false}]
                 (each [k v (pairs options)]
                   (tset vim.opt_local k v))))})

;; после чтения файла - расшифровываем его приватным ключём
(autocmd
  ["BufReadPost" "FileReadPost"]
  {:group "age-encryption"
   :pattern "*.age"
   :callback (fn []
			   (vim.cmd "silent % !age -d -i ~/.ssh/id_ed25519"))})

;; перед записью файла - зашифровываем на публичном ключе
(autocmd
  ["BufWritePre" "FileWritePre"]
  {:group "age-encryption"
   :pattern "*.age"
   :callback (fn []
			   (vim.cmd "silent % !age -e -R ~/.ssh/id_ed25519.pub -a"))})

;; после записи файла возвращаем в буфер расшифрованный вид
(autocmd
  ["BufWritePost" "FileWritePost"]
  {:group "age-encryption"
   :pattern "*.age"
   :command "silent u"})


(augroup "out" {:clear true})
(autocmd
  ["BufReadCmd"]
  {:group "out"
   :pattern "out://*"
   :callback (fn [args]
               (let [bufopt (. vim.bo args.buf)
                     output (-> args.match (string.gsub "^out://" "") vim.fn.expand vim.fn.system (str.split "\n"))]
                 (each [k v (pairs {:buftype "nofile"
                                    :bufhidden "wipe"
                                    :swapfile false
                                    :modifiable true})]
                   (tset bufopt k v))
                 (vim.api.nvim_buf_set_lines args.buf 0 -1 false output)))})


(local lsp-mappings
       [["textDocument/declaration"    "gD"        "<cmd>lua vim.lsp.buf.declaration()<CR>"]
        ["textDocument/definition"     "gd"        "<cmd>lua vim.lsp.buf.definition()<CR>"]
        ["textDocument/implementation" "gi"        "<cmd>lua vim.lsp.buf.implementation()<CR>"]
        ["textDocument/references"     "gr"        "<cmd>lua vim.lsp.buf.references()<CR>"]
        ["textDocument/hover"          "K"         "<cmd>lua vim.lsp.buf.hover()<CR>"]
        ["textDocument/signatureHelp"  "<space>k"  "<cmd>lua vim.lsp.buf.signature_help()<CR>"]
        ["textDocument/rename"         "<space>rn" "<cmd>lua vim.lsp.buf.rename()<CR>"]
        ["textDocument/codeAction"     "<space>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>"]
        [nil                           "<space>wa" "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"]
        [nil                           "<space>wr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"]
        [nil                           "<space>wl" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"]
        [nil                           "[d"        "<cmd>lua vim.diagnostic.jump({count=-1})<CR>"]
        [nil                           "]d"        "<cmd>lua vim.diagnostic.jump({count=1})<CR>"]
        [nil                           "<space>e"  "<cmd>lua vim.diagnostic.open_float()<CR>"]
        [nil                           "<space>q"  "<cmd>lua vim.diagnostic.setloclist()<CR>"]])

(augroup "mylsp" {:clear true})
(autocmd
  ["LspAttach"]
  {:group "mylsp"
  :callback (fn [ev]
              (let [client (vim.lsp.get_client_by_id ev.data.client_id)]
                (each [_ mapping (ipairs lsp-mappings)]
                  (let [[condition key command] mapping]
                    (when (or (core.nil? condition)
                              (client:supports_method condition))
                      (vim.keymap.set "n" key command {:silent true :desc "Link for quickfix"}))))))})
