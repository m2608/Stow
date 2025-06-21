-- [nfnl] fnl/plugins/which-key.fnl
local core = require("nfnl.core")
local function _1_()
  core.assoc(vim.o, "timeout", true)
  core.assoc(vim.o, "timeoutlen", 300)
  return require("which-key").setup({})
end
return {"folke/which-key.nvim", config = _1_}
