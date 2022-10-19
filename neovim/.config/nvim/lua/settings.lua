local _2afile_2a = "/usr/home/undume/.config/nvim/fnl/settings.fnl"
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
local function file_exists_3f(filename)
  local file = io.open(filename)
  local exists = (file ~= nil)
  if exists then
    io.close(file)
  else
  end
  return exists
end
_2amodule_2a["file-exists?"] = file_exists_3f
do
  local lang_mappings = {"\209\145`", "\208\185q", "\209\134w", "\209\131e", "\208\186r", "\208\181t", "\208\189y", "\208\179u", "\209\136i", "\209\137o", "\208\183p", "\209\133[", "\209\138]", "\209\132a", "\209\139s", "\208\178d", "\208\176f", "\208\191g", "\209\128h", "\208\190j", "\208\187k", "\208\180l", "\208\182;", "\209\141'", "\209\143z", "\209\135x", "\209\129c", "\208\188v", "\208\184b", "\209\130n", "\209\140m", "\208\177,", "\209\142.", "\208\129~", "\208\153Q", "\208\166W", "\208\163E", "\208\154R", "\208\149T", "\208\157Y", "\208\147U", "\208\168I", "\208\169O", "\208\151P", "\208\165{", "\208\170}", "\208\164A", "\208\171S", "\208\146D", "\208\144F", "\208\159G", "\208\160H", "\208\158J", "\208\155K", "\208\148L", "\208\150:", "\208\173\"", "\208\175Z", "\208\167X", "\208\161C", "\208\156V", "\208\152B", "\208\162N", "\208\172M", "\208\145<", "\208\174>"}
  local options
  local function _2_(m)
    local function _3_(m0, escaped_char)
      return string.gsub(m0, escaped_char, ("\\" .. escaped_char))
    end
    return core.reduce(_3_, m, {"\\", "\"", "|", ",", ";"})
  end
  options = {{"tabstop", 4}, {"expandtab", true}, {"shiftwidth", 4}, {"relativenumber", true}, {"number", true}, {"signcolumn", "yes"}, {"splitright", true}, {"keymap", "russian-jcukenwin2"}, {"iminsert", 0}, {"imsearch", 0}, {"langmap", table.concat(core.map(_2_, lang_mappings), ",")}, {"ignorecase", true}, {"smartcase", true}, {"foldenable", true}, {"path", (core.get(nvim.o, "path") .. "**")}, {"guifont", "Iosevka:h14"}}
  for _, option in ipairs(options) do
    local name = option[1]
    local value = option[2]
    core.assoc(nvim.o, name, value)
  end
end
do
  local commands = {"autocmd FileType make setlocal noexpandtab", "autocmd FileType javascript setlocal ts=3 sts=3 sw=3", "autocmd FileType vue setlocal ts=2 sts=2 sw=2", "autocmd BufRead,BufNewFile *.bb set filetype=clojure", "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif", "autocmd InsertLeave * if pumvisible() == 0|pclose|endif", "highlight lCursor guifg=NONE guibg=Cyan cterm=none ctermfg=none ctermbg=214", "language en_US.UTF-8", "autocmd CursorHold * lua vim.diagnostic.open_float()"}
  for _, cmd in ipairs(commands) do
    nvim.command(cmd)
  end
end
do
  local colorscheme_filename = (os.getenv("HOME") .. "/.vimrc_background")
  if file_exists_3f(colorscheme_filename) then
    core.assoc(nvim.g, "base16colorspace", 256)
    nvim.command(("source" .. colorscheme_filename))
  else
  end
end
vim.diagnostic.config({virtual_text = false, signs = true, float = {source = "always", border = "single"}})
if core.get(nvim.g, "started_by_firenvim", nil) then
  core.assoc(nvim.o, "laststatus", 0)
  core.assoc(nvim.o, "guifont", "Iosevka:h12")
  nvim.command("colorscheme morning")
else
end
return _2amodule_2a