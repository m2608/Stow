(local core (require "nfnl.core"))
;
; {1 "neovim/nvim-lspconfig"
;  :lazy true
;  :ft ["c" "clojure" "cpp" "edn" "python" "markdown"]
;  :config
;  (fn []
;    (let [servers {:pyright {}
;                   :clojure_lsp {:flags {:completion {:analysis-type :slow-but-accurate}}
;                                 :single_file_support true}
;                   :fennel {:cmd ["fennel-ls"]}
;                   :markdown {:cmd ["markdown-oxide"]
;                              :flags {:debounce_text_changes 150}
;                              :filetypes ["markdown"]
;                              :single_file_support true}
;                   :clangd {}}]
;      (each [name config (pairs servers)]
;        (vim.lsp.config
;          name (core.merge config {:on_attach on-attach}))
;        (vim.lsp.enable name))))}

{1 "neovim/nvim-lspconfig"
 :lazy true
 :ft ["c" "clojure" "cpp" "edn" "python" "markdown"]
 :config
 (fn []
   (let [servers {"markdown_oxide" {}
                  "clojure_lsp"    {}
                  "pyright"        {}}]
     (each [name config (pairs servers)]
       (vim.lsp.enable name))))}
