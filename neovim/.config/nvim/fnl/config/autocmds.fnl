(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))

(local augroup vim.api.nvim_create_augroup)
(local autocmd vim.api.nvim_create_autocmd)

;; Установка формата для файлов *.bqn.
(autocmd
  ["BufRead" "BufNewFile"]
  {:pattern "*.bqn"
   :command "setf bqn"})

;; Настройка комментариев для hurl.
(autocmd
  ["BufNewFile" "BufRead"]
  {:pattern "*.hurl"
   :command "setlocal commentstring=#\\ %s"})

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
   :callback (fn [e]
               (set vim.opt_local.conceallevel 2))})

;; автокомманда для патчинга цветовой схемы; чтобы она сработала, схема должна
;; устанавливаться где-то в конфиге - т.е. даже если мы хотим использовать
;; дефолтную схему, нужно явно её задать
(augroup "colorscheme-patch" {:clear true})
(autocmd
  "ColorScheme"
  {:group "colorscheme-patch"
   :pattern "default"
   :callback (fn []
               (core.assoc vim.o "termguicolors" false)
               (vim.api.nvim_set_hl 0 "Visual" {:ctermfg 0 :ctermbg 15}))})

