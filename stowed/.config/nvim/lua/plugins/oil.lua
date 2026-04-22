-- [nfnl] fnl/plugins/oil.fnl
local function _1_()
  local setup = require("oil").setup
  return setup({default_file_explorer = true, columns = {"permissions", "size", "icon"}, keymaps = {["."] = {"actions.toggle_hidden", mode = "n"}, ["<BS>"] = {"actions.parent", mode = "n"}}, float = {border = "single", padding = 10}, progress = {border = "single"}, confirmation = {border = "single"}, ssh = {border = "single"}, keymaps_help = {border = "single"}})
end
return {"stevearc/oil.nvim", lazy = true, config = _1_, cmd = {"Oil"}}
