(module autocmds
        {autoload {nvim aniseed.nvim
                   core aniseed.core}
        import-macros [[ac :aniseed.macros.autocmds]]})

;; Настройка Firenvim.
(ac.autocmd
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
