-- [nfnl] fnl/plugins/telescope-undo.fnl
local function _1_(_, opts)
  local telescope = require("telescope")
  telescope.setup({extensions = {undo = {initial_mode = "normal", use_delta = false}}})
  return telescope.load_extension("undo")
end
return {"debugloop/telescope-undo.nvim", dependencies = {"nvim-telescope/telescope.nvim"}, config = _1_}
