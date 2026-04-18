-- [nfnl] fnl/plugins/lualine.fnl
local function _1_()
  local setup = require("lualine").setup
  return setup({options = {theme = "auto", component_separators = {left = "|", right = "|"}, section_separators = {left = "", right = ""}, icons_enabled = false}, sections = {lualine_c = {{"filename", path = 1}}}})
end
return {"nvim-lualine/lualine.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}, config = _1_}
