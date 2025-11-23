(local core (require "nfnl.core"))

{1 "mlochbaum/BQN"
 :ft "bqn"
 :enabled false
 :lazy false
 :config (fn [plugin]
           (let [plugin-dir (.. (. plugin "dir") "/editors/vim")]
             (vim.opt.rtp:append plugin-dir)))}
