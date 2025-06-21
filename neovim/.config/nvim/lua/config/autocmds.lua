-- [nfnl] fnl/config/autocmds.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local function _2_(event)
  local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
  if (client and (client.name == "Firenvim")) then
    for _, option in ipairs({{"laststatus", 0}, {"columns", 200}, {"lines", 50}, {"background", "light"}, {"guifont", "Iosevka:h14"}, {"cmdheight", 0}}) do
      local name = option[1]
      local value = option[2]
      core.assoc(vim.o, name, value)
    end
    return nil
  else
    return nil
  end
end
autocmd({"UIEnter"}, {callback = _2_})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.bqn", command = "setf bqn"})
autocmd({"BufNewFile", "BufRead"}, {pattern = "*.hurl", command = "setlocal commentstring=#\\ %s"})
local function _4_(event)
  local prefix = "\\"
  local mappings = {{"`", "\203\156"}, {"1", "\203\152"}, {"2", "\194\168"}, {"3", "\226\129\188"}, {"4", "\226\140\156"}, {"5", "\194\180"}, {"6", "\203\157"}, {"7", "7"}, {"8", "\226\136\158"}, {"9", "\194\175"}, {"0", "\226\128\162"}, {"-", "\195\183"}, {"=", "\195\151"}, {"~", "\194\172"}, {"!", "\226\142\137"}, {"@", "\226\154\135"}, {"#", "\226\141\159"}, {"$", "\226\151\182"}, {"%", "\226\138\152"}, {"^", "\226\142\138"}, {"&", "\226\141\142"}, {"*", "\226\141\149"}, {"(", "\226\159\168"}, {")", "\226\159\169"}, {"_", "\226\136\154"}, {"+", "\226\139\134"}, {"q", "\226\140\189"}, {"w", "\240\157\149\168"}, {"e", "\226\136\138"}, {"r", "\226\134\145"}, {"t", "\226\136\167"}, {"y", "y"}, {"u", "\226\138\148"}, {"i", "\226\138\143"}, {"o", "\226\138\144"}, {"p", "\207\128"}, {"[", "\226\134\144"}, {"]", "\226\134\146"}, {"Q", "\226\134\153"}, {"W", "\240\157\149\142"}, {"E", "\226\141\183"}, {"R", "\240\157\149\163"}, {"T", "\226\141\139"}, {"Y", "Y"}, {"U", "U"}, {"I", "\226\138\145"}, {"O", "\226\138\146"}, {"P", "\226\141\179"}, {"{", "\226\138\163"}, {"}", "\226\138\162"}, {"a", "\226\141\137"}, {"s", "\240\157\149\164"}, {"d", "\226\134\149"}, {"f", "\240\157\149\151"}, {"g", "\240\157\149\152"}, {"h", "\226\138\184"}, {"j", "\226\136\152"}, {"k", "\226\151\139"}, {"l", "\226\159\156"}, {";", "\226\139\132"}, {"'", "\226\134\169"}, {"\\", "\\"}, {"A", "\226\134\150"}, {"S", "\240\157\149\138"}, {"D", "D"}, {"F", "\240\157\148\189"}, {"G", "\240\157\148\190"}, {"H", "\194\171"}, {"J", "J"}, {"K", "\226\140\190"}, {"L", "\194\187"}, {":", "\194\183"}, {"\"", "\203\153"}, {"|", "|"}, {"z", "\226\165\138"}, {"x", "\240\157\149\169"}, {"c", "\226\134\147"}, {"v", "\226\136\168"}, {"b", "\226\140\138"}, {"n", "n"}, {"m", "\226\137\161"}, {",", "\226\136\190"}, {".", "\226\137\141"}, {"/", "\226\137\160"}, {"Z", "\226\139\136"}, {"X", "\240\157\149\143"}, {"C", "C"}, {"V", "\226\141\146"}, {"B", "\226\140\136"}, {"N", "N"}, {"M", "\226\137\162"}, {"<", "\226\137\164"}, {">", "\226\137\165"}, {"?", "\226\135\144"}, {"<space>", "\226\128\191"}}
  for _, _5_ in ipairs(mappings) do
    local m = _5_[1]
    local k = _5_[2]
    vim.keymap.set("i", (prefix .. m), k, {buffer = event.buf})
  end
  return nil
end
autocmd({"FileType"}, {pattern = "bqn", callback = _4_})
augroup("markdown-conceal", {clear = true})
local function _6_(e)
  vim.opt_local.conceallevel = 2
  return nil
end
return autocmd("Filetype", {group = "markdown-conceal", pattern = "markdown", callback = _6_})
