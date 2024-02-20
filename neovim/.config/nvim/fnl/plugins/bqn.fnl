(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "mlochbaum/BQN"
 :ft "bqn"
 :enabled false
 :lazy false
 :config (fn [plugin]
           (let [plugin-dir (.. (. plugin "dir") "/editors/vim")]
             (vim.opt.rtp:append plugin-dir)))}
