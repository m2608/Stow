-- [nfnl] fnl/plugins/lispdocs.fnl
local core = require("nfnl.core")
local function _1_()
  return core.assoc(vim.g, "lispdocs_mappings", 0)
end
return {"kkharji/lispdocs.nvim", lazy = true, dependencies = {"kkharji/sqlite.lua"}, config = _1_}
