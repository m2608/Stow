(local core (require "nfnl.core"))

{1 "hrsh7th/nvim-cmp"
 :dependencies ["hrsh7th/cmp-nvim-lsp" "PaterJason/cmp-conjure" "Olical/conjure"]
 :config (fn []
           (let [cmp (require "cmp")]
             (cmp.setup {:sources (cmp.config.sources (core.map (fn [n] {:name n}) ["conjure" "nvim_lsp" "buffer"]))
                         :mapping {
                             "<C-n>" (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})
                             "<C-p>" (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                             "<CR>"  (cmp.mapping.confirm {:select true})
                             "<Esc>" (cmp.mapping.abort)
                         }})))}
