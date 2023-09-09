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
                                  [:guifont "Iosevka:h14"]
                                  [:lines 25]
                                  [:columns 200]
                                  ])]
           (let [name (. option 1)
                 value (. option 2)]
             (core.assoc nvim.o name value))))))})
