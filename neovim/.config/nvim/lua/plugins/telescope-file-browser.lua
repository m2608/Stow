-- [nfnl] fnl/plugins/telescope-file-browser.fnl
local function _1_(_, opts)
  local telescope = require("telescope")
  local fb_actions = require("telescope._extensions.file_browser.actions")
  telescope.setup({extensions = {file_browser = {hijack_netrw = true, grouped = true, follow_symlinks = true, preview = {hide_on_startup = true, check_mime_type = false}, initial_mode = "normal", dir_icon = " ", sorting_strategy = "ascending", mappings = {n = {["."] = fb_actions.toggle_hidden, l = fb_actions.open_dir, h = fb_actions.goto_parent_dir, ["~"] = fb_actions.goto_home_dir, e = fb_actions.open, c = fb_actions.copy, n = fb_actions.create}}, respect_gitignore = false}}})
  return telescope.load_extension("file_browser")
end
return {"nvim-telescope/telescope-file-browser.nvim", dependencies = {"nvim-telescope/telescope.nvim"}, config = _1_}
