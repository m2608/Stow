{1 "hkupty/iron.nvim"
 :config
 (fn []
   (let [core (require "iron.core")
         view (require "iron.view")]
     ((. core :setup)
      {:config
       {:scratch_repl true
        :repl_definition
        {:sh
         {:command ["sh"]}
         :python
         {:command ["python3"]}
         :cljs
         {:command ["nbb" "nrepl-server"]}}
        :repl_open_cmd
        ((. view :bottom) 20)}
       :keymaps
       {:send_motion "<space>sc"
        :visual_send "<space>sc"
        :send_file "<space>sf"
        :send_line "<space>sl"
        :send_mark "<space>sm"
        :mark_motion "<space>mc"
        :mark_visual "<space>mc"
        :remove_mark "<space>md"
        :cr "<space>s<cr>"
        :interrupt "<space>s<space>"
        :exit "<space>sq"
        :clear "<space>cl"}})))}
