(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "jpalardy/vim-slime"
 :config (fn []
           (let [options [["slime_target" "tmux"]                          
                          ["slime_default_config" {:socket_name "default"
                                                   :target_pane "{last}"}]
                          ["slime_dont_ask_default" 1]]]
                 (each [_ option (ipairs options)]
                   (core.assoc nvim.g (unpack option)))))}
