(local core (require "nfnl.core"))

{1 "hrsh7th/nvim-cmp"
 :dependencies [{1 "hrsh7th/cmp-nvim-lsp" :event "LspAttach"}
                {1 "PaterJason/cmp-conjure"
                 :ft ["clojure" "edn"]
                 :dependencies {1 "Olical/conjure" :lazy true}}
                {1 "kdheepak/cmp-latex-symbols"}]
 :lazy true
 :event ["InsertEnter"]
 :config (fn []
           (let [cmp (require "cmp")]
             (cmp.setup {:sources (cmp.config.sources (core.map (fn [n] {:name n}) ["conjure" "nvim_lsp" "buffer" "latex_symbols"]))
                         :mapping {
                             "<C-n>"   (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})
                             "<C-p>"   (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                             "<CR>"    (cmp.mapping.confirm {:select true})
                             "<Space>" (cmp.mapping (fn [fallback]
                                                      (if (and (cmp.visible) (cmp.get_selected_entry))
                                                          (do
                                                            (cmp.abort)
                                                            (vim.api.nvim_feedkeys " " "n" false))
                                                          (fallback)))
                                                    ["i" "s"])
                         }})))}
