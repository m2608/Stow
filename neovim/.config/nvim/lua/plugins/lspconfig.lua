-- [nfnl] fnl/plugins/lspconfig.fnl
local core = require("nfnl.core")
local mappings
local function _1_(params)
  local result = {}
  table.insert(result, "n")
  local function _2_(p)
    return table.insert(result, p)
  end
  core["run!"](_2_, params)
  table.insert(result, {noremap = true, silent = true})
  return result
end
mappings = core.map(_1_, {{"gD", "<cmd>lua vim.lsp.buf.declaration()<CR>"}, {"gd", "<cmd>lua vim.lsp.buf.definition()<CR>"}, {"gi", "<cmd>lua vim.lsp.buf.implementation()<CR>"}, {"gr", "<cmd>lua vim.lsp.buf.references()<CR>"}, {"K", "<cmd>lua vim.lsp.buf.hover()<CR>"}, {"[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>"}, {"]d", "<cmd>lua vim.diagnostic.goto_next()<CR>"}, {"<space>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>"}, {"<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"}, {"<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"}, {"<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"}, {"<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>"}, {"<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>"}, {"<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>"}, {"<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>"}})
local function on_attach(client, bufnr)
  local buf_set_option
  local function _3_(...)
    return vim.api.nvim_buf_set_option(bufnr, ...)
  end
  buf_set_option = _3_
  local buf_set_keymap
  local function _4_(...)
    return vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  buf_set_keymap = _4_
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  for _, mapping in ipairs(mappings) do
    buf_set_keymap(unpack(mapping))
  end
  return nil
end
local function _5_()
  local servers = {pyright = {}, clojure_lsp = {flags = {debounce_text_changes = 150}}, marksman = {cmd = {"marksman", "server"}, flags = {debounce_text_changes = 150}, single_file_support = true}, clangd = {}}
  vim.lsp.set_log_level("debug")
  for name, config in pairs(servers) do
    vim.lsp.config(name, core.merge(config, {on_attach = on_attach}))
    vim.lsp.enable(name)
  end
  return nil
end
return {"neovim/nvim-lspconfig", config = _5_}
