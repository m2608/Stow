(local core (require "aniseed.core"))
(local nvim (require "aniseed.nvim"))

{1 "jpalardy/vim-slime"
 :lazy true
 :config (fn []
           (let [options [["slime_target" "tmux"]
                          ["slime_default_config" {:socket_name "default"
                                                   :target_pane "{last}"}]
                          ["slime_dont_ask_default" 1]]]
                 (each [_ option (ipairs options)]
                   (core.assoc nvim.g (unpack option)))))
 :cmd ["SlimeConfig"
       "SlimeSend"
       "SlimeSend0"
       "SlimeSend1"
       "SlimeSendCurrentLine"]}
