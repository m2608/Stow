local _2afile_2a = "/usr/home/undume/.config/nvim/fnl/lsp.fnl"
local _2amodule_name_2a = "lsp"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local core, lsp, nvim = autoload("aniseed.core"), autoload("lspconfig"), autoload("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["lsp"] = lsp
_2amodule_locals_2a["nvim"] = nvim
local local_servers = {"pylsp", "clojure_lsp"}
_2amodule_locals_2a["local-servers"] = local_servers
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
mappings = core.map(_1_, {{"gD", "<cmd>lua vim.lsp.buf.declaration()<CR>"}, {"gd", "<cmd>lua vim.lsp.buf.definition()<CR>"}, {"K", "<cmd>lua vim.lsp.buf.hover()<CR>"}, {"gi", "<cmd>lua vim.lsp.buf.implementation()<CR>"}, {"gr", "<cmd>lua vim.lsp.buf.references()<CR>"}, {"[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>"}, {"]d", "<cmd>lua vim.diagnostic.goto_next()<CR>"}, {"<space>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>"}, {"<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"}, {"<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"}, {"<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"}, {"<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>"}, {"<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>"}, {"<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>"}, {"<space>e", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>"}, {"<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"}, {"<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>"}})
do end (_2amodule_locals_2a)["mappings"] = mappings
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
_2amodule_2a["on-attach"] = on_attach
for _, server in ipairs(local_servers) do
  lsp[server].setup({on_attach = on_attach, flags = {debounce_text_changes = 150}})
end
return _2amodule_2a