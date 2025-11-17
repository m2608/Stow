-- [nfnl] fnl/config/keymaps.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local function set_mapping(mode, from, to, ...)
  local opts
  if (#{...} == 0) then
    opts = {noremap = true, silent = true}
  else
    opts = ({...})[1]
  end
  return vim.keymap.set(mode, from, to, opts)
end
local function yank_for_quickfix()
  local filename = vim.fn.expand("%:.")
  local _let_3_ = vim.fn.getcurpos()
  local _ = _let_3_[1]
  local row = _let_3_[2]
  local column = _let_3_[3]
  local _0 = _let_3_[4]
  local _1 = _let_3_[5]
  return vim.fn.setreg("", (filename .. ":" .. row .. ":" .. column .. ":" .. vim.api.nvim_get_current_line()))
end
vim.keymap.set("n", "yq", yank_for_quickfix, {silent = true, desc = "Link for quickfix"})
local mappings = {{"n", "<F2>", ":<C-u>update<CR>"}, {"i", "<F2>", "<C-o>:update<CR>"}, {"n", "<F8>", ":<C-u>AerialToggle<CR>"}, {"n", "<F9>", ":Telescope file_browser path=%:h<CR>"}, {"n", "<F10>", ":ToggleTerm<CR>"}, {"n", "<F11>", ":ZenMode<CR>"}, {"n", "<F11>", "<C-o>:ZenMode<CR>"}, {"n", "<BS>", ":nohlsearch<CR>"}, {"n", "<Leader><BS>", ":lua vim.diagnostic.hide()<CR>"}, {"n", "<Leader>e", ":e <C-R>=expand(\"%:p:h\") . \"/\"<CR>", {noremap = true}}, {"n", "<Leader>cd", ":lcd %:p:h<CR>:pwd<CR>", {noremap = true}}, {"v", "<", "<gv"}, {"v", ">", ">gv"}, {"i", "<Tab>", "pumvisible() ? \"<Down>\" : \"<Tab>\"", {noremap = true, silent = true, expr = true}}, {"i", "<S-Tab>", "pumvisible() ? \"<Up>\"   : \"\"", {noremap = true, silent = true, expr = true}}, {"i", "<C-n>", "pumvisible() ? \"<Down>\" : \"<C-x><C-o>\"", {noremap = true, silent = true, expr = true}}, {"i", "<C-p>", "pumvisible() ? \"<Up\"    : \"<C-x><C-o>\"", {noremap = true, silent = true, expr = true}}, {"i", "<CR>", "pumvisible() ? \"<c-y>\" : \"<cr>\"", {noremap = true, silent = true, expr = true}}, {"n", "Y", "y$"}, {"n", "<C-Tab>", ":wincmd w<CR>"}, {"n", "<C-S-Tab>", ":wincmd W<CR>"}, {"n", "gh", "^"}, {"n", "gl", "$"}, {"n", "<m-x>", ":", {noremap = true, silent = false}}, {"i", "<c-e>", "<c-o>$"}, {"i", "<c-a>", "<c-o>^"}, {"c", "<c-a>", "<home>", {noremap = true}}, {"c", "<c-e>", "<end>", {noremap = true}}, {"c", "<c-p>", "<up>", {noremap = true}}, {"c", "<c-n>", "<down>", {noremap = true}}, {"c", "<c-b>", "<left>", {noremap = true}}, {"c", "<c-f>", "<right>", {noremap = true}}, {"c", "<m-b>", "<s-left>", {noremap = true}}, {"c", "<m-f>", "<s-right>", {noremap = true}}, {"n", "<c-j>", ":cn<CR>"}, {"n", "<c-k>", ":cp<CR>"}, {"n", "<F3>", "yiw:vimgrep /<c-r>0/ **/*", {noremap = true}}, {"n", "gx", ":silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>"}, {"v", "gx", "y | :silent execute '!xdg-open ' . shellescape(expand(@\"), 1)<CR>"}, {"n", "<space>f", ":Telescope find_files<CR>"}, {"n", "<space>F", ":Telescope file_browser<CR>"}, {"n", "<space>b", ":Telescope buffers<CR>"}, {"n", "<space>/", ":Telescope live_grep<CR>"}, {"n", "<space>g", ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>"}, {"n", "<space>d", ":Telescope diagnostics<CR>"}, {"n", "<space>s", ":Telescope lsp_document_symbols<CR>"}, {"n", "<space>r", ":Telescope lsp_references<CR>"}, {"n", "<space>j", ":Telescope jumplist<CR>"}, {"n", "<space>u", ":Telescope undo<CR>"}, {"n", "<Leader>fh", ":Telescope help_tags<CR>"}, {"n", "<Leader>fd", ":Telescope lsp_definitions<CR>"}, {"x", "<Leader>s", "<Plug>SlimeRegionSend", {silent = true, noremap = false}}, {"n", "<Leader>s", "<Plug>SlimeParagraphSend", {silent = true, noremap = false}}, {"t", "<Esc>", "<C-\\><C-n>"}, {"n", "<space>y", ":OSCYankOperator<CR>", {silent = true, noremap = false}}, {"v", "<space>y", ":OSCYankVisual<CR>", {silent = true, noremap = false}}, {"n", "<space>h", ":w !xclip -selection clipboard -t text/html<CR>", {silent = true, noremap = false}}, {"v", "<space>h", ":w !xclip -selection clipboard -t text/html<CR>", {silent = true, noremap = false}}, {"n", "<space>p", "\"+p"}, {"n", "<space>P", "\"+P"}, {"n", "<A-h>", "<CMD>NavigatorLeft<CR>"}, {"n", "<A-l>", "<CMD>NavigatorRight<CR>"}, {"n", "<A-k>", "<CMD>NavigatorUp<CR>"}, {"n", "<A-j>", "<CMD>NavigatorDown<CR>"}}
for _, mapping in ipairs(mappings) do
  set_mapping(unpack(mapping))
end
return nil
