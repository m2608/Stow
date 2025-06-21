-- [nfnl] fnl/plugins/mason.fnl
local function _1_()
  local setup = require("mason").setup
  return setup()
end
return {"williamboman/mason.nvim", lazy = (vim.fn.trim(vim.fn.system("uname")) ~= "Linux"), config = _1_}
