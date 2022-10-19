local _2afile_2a = "/usr/home/undume/.config/nvim/fnl/keymaps.fnl"
local _2amodule_name_2a = "settings"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local core, nvim = autoload("aniseed.core"), autoload("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
local function set_mapping(mode, from, to, ...)
  local opts
  if (#{...} == 0) then
    opts = {noremap = true, silent = true}
  else
    opts = ({...})[1]
  end
  return nvim.set_keymap(mode, from, to, opts)
end
_2amodule_locals_2a["set-mapping"] = set_mapping
local mappings = {{"n", "<F8>", ":TagbarToggle<CR>"}, {"n", "<F2>", ":NvimTreeToggle<CR>"}, {"n", "<BS>", ":nohlsearch<CR>"}, {"n", "<Leader><BS>", ":lua vim.diagnostic.hide()<CR>"}, {"n", "<space>", "za"}, {"n", "<Leader>e", ":e <C-R>=expand(\"%:p:h\") . \"/\"<CR>", {noremap = true}}, {"n", "<Leader>cd", ":lcd %:p:h<CR>:pwd<CR>", {noremap = true}}, {"v", "<", "<gv"}, {"v", ">", ">gv"}, {"i", "<c-space>", "<c-x><c-o>"}, {"i", "<cr>", "pumvisible() ? \"<c-y>\" : \"<cr>\"", {noremap = true, silent = true, expr = true}}, {"n", "Y", "y$"}, {"i", "<c-e>", "<c-o>$"}, {"i", "<c-a>", "<c-o>^"}, {"c", "<c-a>", "<home>", {noremap = true}}, {"c", "<c-e>", "<end>", {noremap = true}}, {"c", "<c-p>", "<up>", {noremap = true}}, {"c", "<c-n>", "<down>", {noremap = true}}, {"c", "<c-b>", "<left>", {noremap = true}}, {"c", "<c-f>", "<right>", {noremap = true}}, {"c", "<m-b>", "<s-left>", {noremap = true}}, {"c", "<m-f>", "<s-right>", {noremap = true}}, {"n", "<c-j>", ":cn<CR>"}, {"n", "<c-k>", ":cp<CR>"}, {"n", "<F3>", "yiw:vimgrep /<c-r>0/ **/*", {noremap = true}}, {"n", "gx", ":silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>"}, {"v", "gx", "y | :silent execute '!xdg-open ' . shellescape(expand(@\"), 1)<CR>"}, {"n", "<Leader>ff", ":Telescope find_files<CR>"}, {"n", "<Leader>fb", ":Telescope buffers<CR>"}, {"n", "<Leader>fg", ":Telescope live_grep<CR>"}, {"n", "<Leader>fh", ":Telescope help_tags<CR>"}, {"x", "<Leader>s", "<Plug>SlimeRegionSend", {noremap = false, silent = true}}, {"n", "<Leader>s", "<Plug>SlimeParagraphSend", {noremap = false, silent = true}}, {"t", "<Esc>", "<C-\\><C-n>"}, {"i", "<Leader>l", "<c-v>u03bb"}}
_2amodule_locals_2a["mappings"] = mappings
for _, mapping in ipairs(mappings) do
  set_mapping(unpack(mapping))
end
return _2amodule_2a