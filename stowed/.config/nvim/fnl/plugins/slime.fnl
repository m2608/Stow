{1 "jpalardy/vim-slime"
 :lazy true
 :config (fn []
           (let [options [["slime_target" "tmux"]
                          ["slime_default_config" {:socket_name "default"
                                                   :target_pane "{last}"}]
                          ["slime_dont_ask_default" 1]]]
                 (each [_ [k v] (ipairs options)]
                   (tset vim.g k v))))
 :cmd ["SlimeConfig"
       "SlimeSend"
       "SlimeSend0"
       "SlimeSend1"
       "SlimeSendCurrentLine"
       "SlimeRegionSend"]}
