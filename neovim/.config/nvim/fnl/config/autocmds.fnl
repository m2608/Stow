(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

;; Настройка Firenvim.
(vim.api.nvim_create_autocmd
  ["UIEnter"]
  {:callback
   (fn [event]
     (let [client (. (vim.api.nvim_get_chan_info nvim.v.event.chan) "client")]
       (when (and client (= client.name "Firenvim"))
         (each [_ option (ipairs [[:laststatus 0]
                                  [:guifont "APL386 Unicode:h16"]
                                  [:cmdheight 0]])]
           (let [name (. option 1)
                 value (. option 2)]
             (core.assoc nvim.o name value))))))})

;; Установка формата для файлов *.bqn.
(vim.api.nvim_create_autocmd
  ["BufRead" "BufNewFile"]
  {:pattern "*.bqn"
   :command "setf bqn"})

;; Маппинги символов BQN для файлов соответствующего типа.
(vim.api.nvim_create_autocmd
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
