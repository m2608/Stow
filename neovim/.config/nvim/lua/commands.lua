local _2afile_2a = "/usr/home/undume/.config/nvim/fnl/commands.fnl"
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
local nvim = autoload("aniseed.nvim")
do end (_2amodule_locals_2a)["nvim"] = nvim
local function cmd(...)
  return nvim.command(...)
end
_2amodule_locals_2a["cmd"] = cmd
cmd(("command! -range URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "print(quote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range URLdecode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "print(unquote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range B64encode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64encode;" .. "print(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64decode;" .. "print(b64decode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "from base64 import b64encode;" .. "print(quote(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8')));" .. "\""))
cmd(("command! -range URLB64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "from base64 import b64decode;" .. "print(b64decode(unquote(sys.stdin.read().strip()).encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range GitLab " .. "execute 'silent ! git browse \"' . expand('%') . '\" ' . <line1> | checktime | redraw!"))
return _2amodule_2a