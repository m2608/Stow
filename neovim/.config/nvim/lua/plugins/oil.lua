-- [nfnl] fnl/plugins/oil.fnl
local function _1_()
  local setup = require("oil").setup
  return setup({columns = {"icon"}, default_file_explorer = false})
end
return {"stevearc/oil.nvim", lazy = true, config = _1_, cmd = {"Oil"}}
