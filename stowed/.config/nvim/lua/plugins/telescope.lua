-- [nfnl] fnl/plugins/telescope.fnl
local function _1_()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local layout = require("telescope.actions.layout")
  local fb_actions = require("telescope._extensions.file_browser.actions")
  telescope.setup({defaults = {preview = {check_mime_type = true}, file_ignore_patterns = {}, mappings = {i = {["<C-y>"] = layout.toggle_preview, ["<C-b>"] = {"<left>", type = "command"}, ["<C-f>"] = {"<right>", type = "command"}, ["<M-b>"] = {"<S-left>", type = "command"}, ["<M-f>"] = {"<S-right>", type = "command"}, ["<C-a>"] = {"<home>", type = "command"}, ["<C-e>"] = {"<end>", type = "command"}, ["<C-u>"] = false}, n = {["<C-y>"] = layout.toggle_preview}}}, pickers = {buffers = {mappings = {n = {d = actions.delete_buffer}}}, find_files = {follow = true, disable_devicons = true}}, extensions = {file_browser = {hijack_netrw = true, grouped = true, follow_symlinks = true, preview = {hide_on_startup = true, check_mime_type = false}, initial_mode = "normal", dir_icon = " ", disable_devicons = true, sorting_strategy = "ascending", mappings = {n = {["."] = fb_actions.toggle_hidden, g = fb_actions.toggle_respect_gitignore, l = fb_actions.open_dir, h = fb_actions.goto_parent_dir, ["~"] = fb_actions.goto_home_dir, e = fb_actions.open, c = fb_actions.copy, n = fb_actions.create}}, respect_gitignore = false}, undo = {initial_mode = "normal", use_delta = false}, ast_grep = {command = {"ast-grep", "--json=stream"}, lang = nil, grep_open_files = false}}})
  telescope.load_extension("file_browser")
  telescope.load_extension("undo")
  return telescope.load_extension("ast_grep")
end
return {"nvim-telescope/telescope.nvim", tag = "v0.2.1", dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim", "debugloop/telescope-undo.nvim", "Marskey/telescope-sg"}, config = _1_}
