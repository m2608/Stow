-- [nfnl] fnl/config/commands.fnl
local _local_1_ = require("nfnl.core")
local filter = _local_1_.filter
local function starts_with_3f(s, prefix)
  return (prefix == string.sub(s, 1, #prefix))
end
local function cmd(...)
  return vim.cmd(...)
end
cmd(("command! -range URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "print(quote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range URLdecode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "print(unquote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range B64encode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64encode;" .. "print(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64decode;" .. "print(b64decode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "from base64 import b64encode;" .. "print(quote(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8')));" .. "\""))
cmd(("command! -range URLB64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "from base64 import b64decode;" .. "print(b64decode(unquote(sys.stdin.read().strip()).encode('utf-8')).decode('utf-8'));" .. "\""))
local function _2_(opts)
  local path = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local case_3_ = opts.args
  if (case_3_ == "open") then
    return vim.system({"git", "browse", "-o", path, line})
  elseif (case_3_ == "show") then
    local function _4_(o)
      return print(o.stdout)
    end
    return vim.system({"git", "browse", "-s", path, line}, {text = true}, _4_)
  elseif (case_3_ == "yank") then
    local function _5_(o)
      local output = string.gsub(o.stdout, "[\n]+$", "")
      local function _6_()
        return vim.call("OSCYank", output)
      end
      return vim.schedule(_6_)
    end
    return vim.system({"git", "browse", "-s", path, line}, {text = true}, _5_)
  else
    local _ = case_3_
    return print(("Unknown subcommand: " .. opts.args))
  end
end
local function _8_(arglead, _, _0)
  local subcommands = {"open", "show", "yank"}
  local function _9_(c)
    return starts_with_3f(c, arglead)
  end
  return filter(_9_, subcommands)
end
vim.api.nvim_create_user_command("Gitlab", _2_, {nargs = 1, complete = _8_, desc = "\208\159\208\190\208\187\209\131\209\135\208\184\209\130\209\140 \209\129\209\129\209\139\208\187\208\186\209\131 \208\189\208\176 \208\184\209\129\209\133\208\190\208\180\208\189\209\139\208\185 \208\186\208\190\208\180 \208\178 GitLab"})
local function _10_()
  local filename = vim.fn.expand("%:p")
  local _let_11_ = vim.api.nvim_win_get_position(0)
  local row = _let_11_[1]
  local col = _let_11_[2]
  local sixeldata = vim.fn.system(string.format("magick convert \"%s\" sixel:- 2> /dev/null", filename))
  return vim.fn.chansend(vim.v.stderr, string.format("\27[s\27[%d;%dH%s\27[u", row, (col + 1), sixeldata))
end
return vim.api.nvim_create_user_command("SixelView", _10_, {nargs = 0})
