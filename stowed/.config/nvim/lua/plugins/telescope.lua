-- [nfnl] fnl/plugins/telescope.fnl
local function _1_()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local layout = require("telescope.actions.layout")
  local fb_actions = require("telescope._extensions.file_browser.actions")
  return telescope.setup({defaults = {preview = {check_mime_type = true}, file_ignore_patterns = {}, mappings = {i = {["<C-y>"] = layout.toggle_preview}, n = {["<C-y>"] = layout.toggle_preview}}}, pickers = {buffers = {mappings = {n = {d = actions.delete_buffer}}}}})
end
return {"nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = {"nvim-lua/plenary.nvim"}, config = _1_}
