-- [nfnl] fnl/plugins/lspconfig.fnl
local core = require("nfnl.core")
local function _1_()
  local servers = {markdown_oxide = {}, clojure_lsp = {}, pyright = {}, ["fennel-ls"] = {}, clangd = {}}
  for name, config in pairs(servers) do
    vim.lsp.enable(name)
  end
  return nil
end
return {"neovim/nvim-lspconfig", lazy = true, ft = {"c", "clojure", "cpp", "edn", "python", "markdown"}, config = _1_}
