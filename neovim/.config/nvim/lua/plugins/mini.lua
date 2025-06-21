-- [nfnl] fnl/plugins/mini.fnl
local function _1_()
  local mini_jump = require("mini.jump")
  local mini_bracketed = require("mini.bracketed")
  mini_jump.setup({})
  return mini_bracketed.setup({})
end
return {"echasnovski/mini.nvim", config = _1_, version = false}
