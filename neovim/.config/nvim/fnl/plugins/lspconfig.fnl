(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

;; Список языковых серверов.
(local servers
  {:pylsp
   {:flags {:debounce_text_changes 150
            :single_file_support true}}
   :clojure_lsp
   {:flags {:debounce_text_changes 150
            :single_file_support true}}
   :marksman
   {:cmd ["marksman" "server"]
    :flags {:debounce_text_changes 150
            :single_file_support true}}
   })

;; Список шоткатов.
(local mappings 
  (core.map 
    (fn [params] 
      (let [result []]
        (table.insert result :n)
        (core.run! (fn [p] (table.insert result p)) params)
        (table.insert result {:noremap true :silent true})
        result))
    [["gD"        "<cmd>lua vim.lsp.buf.declaration()<CR>"]
     ["gd"        "<cmd>lua vim.lsp.buf.definition()<CR>"]
     ["K"         "<cmd>lua vim.lsp.buf.hover()<CR>"]
     ["gi"        "<cmd>lua vim.lsp.buf.implementation()<CR>"]
     ["gr"        "<cmd>lua vim.lsp.buf.references()<CR>"]
     ["[d"        "<cmd>lua vim.diagnostic.goto_prev()<CR>"]
      ["]d"        "<cmd>lua vim.diagnostic.goto_next()<CR>"]
     ["<space>k"  "<cmd>lua vim.lsp.buf.signature_help()<CR>"]
     ["<space>wa" "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"]
     ["<space>wr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"]
     ["<space>wl" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"]
     ["<space>D"  "<cmd>lua vim.lsp.buf.type_definition()<CR>"]
     ["<space>rn" "<cmd>lua vim.lsp.buf.rename()<CR>"]
     ["<space>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>"]
     ["<space>e"  "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>"]
     ["<space>q"  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"]
     ["<space>f"  "<cmd>lua vim.lsp.buf.formatting()<CR>"]]))

(fn on-attach [client bufnr]
  "Функция будет переназначать кнопки только после подключения языкового
  сервера к текущему буферу."
  (let [buf-set-option (fn [...]
                         (vim.api.nvim_buf_set_option bufnr ...))
        buf-set-keymap (fn [...]
                         (vim.api.nvim_buf_set_keymap bufnr ...))]
    (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")
    (each [_ mapping (ipairs mappings)]
      (buf-set-keymap (unpack mapping)))))

[{1 "neovim/nvim-lspconfig"
  :config
  (fn []
    (let [lsp (require "lspconfig")]
      (each [name config (pairs servers)]
        ((. lsp name :setup)
         (core.merge config {:on_attach on-attach})))))}]
