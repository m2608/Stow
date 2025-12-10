-- [nfnl] fnl/config/commands.fnl
local function cmd(...)
  return vim.cmd(...)
end
cmd(("command! -range URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "print(quote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range URLdecode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "print(unquote(sys.stdin.read().strip()));" .. "\""))
cmd(("command! -range B64encode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64encode;" .. "print(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from base64 import b64decode;" .. "print(b64decode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range B64URLencode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import quote;" .. "from base64 import b64encode;" .. "print(quote(b64encode(sys.stdin.read().strip().encode('utf-8')).decode('utf-8')));" .. "\""))
cmd(("command! -range URLB64decode :<line1>,<line2>" .. "!python3 -c \"" .. "import sys;" .. "from urllib.parse import unquote;" .. "from base64 import b64decode;" .. "print(b64decode(unquote(sys.stdin.read().strip()).encode('utf-8')).decode('utf-8'));" .. "\""))
cmd(("command! -range GitLab " .. "execute 'silent ! git browse \"' . expand('%') . '\" ' . <line1> | checktime | redraw!"))
cmd(("command! -range GitLabShow " .. "execute '! git browse -s \"' . expand('%') . '\" ' . <line1>"))
local function _1_()
  local command = {"git", "browse", "-s", vim.fn.expand("%"), tostring(vim.fn.line("."))}
  local function _2_(o)
    local output = string.gsub(o.stdout, "[\n]+$", "")
    local function _3_()
      return vim.call("OSCYank", output)
    end
    return vim.schedule(_3_)
  end
  return vim.system(command, {text = true}, _2_)
end
return vim.api.nvim_create_user_command("GitLabYank", _1_, {nargs = 0})
