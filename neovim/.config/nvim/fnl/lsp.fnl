(module lsp
        {autoload {core aniseed.core
                   nvim aniseed.nvim
                   lsp lspconfig}})

;; Список языковых серверов.
(def- local-servers ["pylsp" "clojure_lsp"])

;; Список шоткатов.
(def- mappings 
  (core.map 
    (fn [params] 
      (let [result []]
        (table.insert result :n)
        (core.run! (fn [p] (table.insert result p)) params)
        (table.insert result {:noremap true :silent true})
        result))
    [["gD" "<cmd>lua vim.lsp.buf.declaration()<CR>"]
     ["gd" "<cmd>lua vim.lsp.buf.definition()<CR>"]
     ["K" "<cmd>lua vim.lsp.buf.hover()<CR>"]
     ["gi" "<cmd>lua vim.lsp.buf.implementation()<CR>"]
     ["gr" "<cmd>lua vim.lsp.buf.references()<CR>"]
     ["[d" "<cmd>lua vim.diagnostic.goto_prev()<CR>"]
     ["]d" "<cmd>lua vim.diagnostic.goto_next()<CR>"]
     ["<space>k" "<cmd>lua vim.lsp.buf.signature_help()<CR>"]
     ["<space>wa" "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"]
     ["<space>wr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"]
     ["<space>wl" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"]
     ["<space>D" "<cmd>lua vim.lsp.buf.type_definition()<CR>"]
     ["<space>rn" "<cmd>lua vim.lsp.buf.rename()<CR>"]
     ["<space>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>"]
     ["<space>e" "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>"]
     ["<space>q" "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"]
     ["<space>f" "<cmd>lua vim.lsp.buf.formatting()<CR>"]]))

(defn on-attach [client bufnr]
  "Функция будет переназначать кнопки только после подключения языкового
  сервера к текущему буферу."
  (let [buf-set-option (fn [...]
                         (vim.api.nvim_buf_set_option bufnr ...))
        buf-set-keymap (fn [...]
                         (vim.api.nvim_buf_set_keymap bufnr ...))]
    (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")
    (each [_ mapping (ipairs mappings)]
      (buf-set-keymap (unpack mapping)))))

(each [_ server (ipairs local-servers)]
  ((. lsp server :setup) {:on_attach on-attach
                          :flags {:debounce_text_changes 150}}))
