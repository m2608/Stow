-- [nfnl] fnl/plugins/oil.fnl
local function _1_()
  local setup = require("oil").setup
  local function _2_()
    local col = 10
    local row = 4
    local w = (vim.o.columns - (2 * col))
    local h = (vim.o.lines - (2 * row) - 4)
    return {relative = "editor", anchor = "NW", col = col, row = row, width = w, height = h, border = {"\226\148\140", "\226\148\128", "\226\148\144", "\226\148\130", "\226\148\152", "\226\148\128", "\226\148\148", "\226\148\130"}}
  end
  return setup({default_file_explorer = true, columns = {"permissions", "size", "icon"}, keymaps = {["."] = {"actions.toggle_hidden", mode = "n"}, ["<BS>"] = {"actions.parent", mode = "n"}}, float = {override = _2_}, progress = {border = "single"}, confirmation = {border = "single"}, ssh = {border = "single"}, keymaps_help = {border = "single"}})
end
return {"stevearc/oil.nvim", lazy = true, config = _1_, cmd = {"Oil"}}
