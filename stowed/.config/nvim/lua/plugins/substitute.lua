-- [nfnl] fnl/plugins/substitute.fnl
local function _1_()
  local substitute = require("substitute")
  substitute.setup({})
  vim.keymap.set("n", "s", substitute.operator, {noremap = true})
  return vim.keymap.set("x", "s", substitute.visual, {noremap = true})
end
return {"gbprod/substitute.nvim", config = _1_}
