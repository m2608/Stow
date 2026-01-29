-- [nfnl] fnl/plugins/telescope.fnl
local function _1_()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local layout = require("telescope.actions.layout")
  local fb_actions = require("telescope._extensions.file_browser.actions")
  return telescope.setup({defaults = {preview = {check_mime_type = true}, file_ignore_patterns = {}, mappings = {i = {["<C-y>"] = layout.toggle_preview, ["<C-b>"] = {"<left>", type = "command"}, ["<C-f>"] = {"<right>", type = "command"}, ["<M-b>"] = {"<S-left>", type = "command"}, ["<M-f>"] = {"<S-right>", type = "command"}, ["<C-a>"] = {"<home>", type = "command"}, ["<C-e>"] = {"<end>", type = "command"}, ["<C-u>"] = false}, n = {["<C-y>"] = layout.toggle_preview}}}, pickers = {buffers = {mappings = {n = {d = actions.delete_buffer}}}, find_files = {no_ignore = true, follow = true, hidden = true}}})
end
return {"nvim-telescope/telescope.nvim", tag = "v0.2.1", dependencies = {"nvim-lua/plenary.nvim"}, config = _1_}
