-- [nfnl] after/ftplugin/scheme.fnl
local _local_1_ = require("nfnl.core")
local some = _local_1_.some
local default_socket = "~/.local/run/guile.socket"
local function vim_b(options)
  for _, option in ipairs(options) do
    local k = option[1]
    local v = option[2]
    vim.b[k] = v
  end
  return nil
end
local function wait_for_something(check_fn, on_success, on_error, attempts, delay)
  if (attempts == 0) then
    return on_error()
  else
    if check_fn() then
      return on_success()
    else
      local function _2_()
        return wait_for_something(check_fn, on_success, on_error, (attempts - 1), delay)
      end
      return vim.fn.timer_start(delay, _2_)
    end
  end
end
local function wait_for_socket(socket_path)
  local function _5_()
    return (vim.fn.getftype(vim.fn.expand(socket_path)) == "socket")
  end
  local function _6_()
    return vim.cmd("ConjureConnect")
  end
  local function _7_()
    return vim.notify("Guile socket was not created.", vim.log.levels.ERROR)
  end
  return wait_for_something(_5_, _6_, _7_, 10, 500)
end
local function guile_run(guile_command, socket)
  local source_win = vim.api.nvim_get_current_win()
  local terminal_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(terminal_buf, true, {split = "below", win = source_win})
  vim.fn.termopen({guile_command, socket})
  return vim.api.nvim_set_current_win(source_win)
end
local function guile_connect(guile_command, socket_path)
  local socket = vim.fn.expand(socket_path)
  vim_b({{"conjure#filetype#scheme", "conjure.client.guile.socket"}, {"conjure#client#guile#socket#pipename", socket}})
  if (vim.fn.getftype(socket) ~= "socket") then
    vim.fn.mkdir(vim.fn.fnamemodify(socket, ":h"), "p")
    guile_run(guile_command, socket)
  else
  end
  return wait_for_socket(socket)
end
local ext = vim.fn.expand("%:e")
if (ext == "scm") then
  local function _9_(_)
    local function _10_(path)
      if (path and (path ~= "")) then
        return guile_connect("guile-repl", path)
      else
        return nil
      end
    end
    return vim.ui.input({prompt = "Guile socket: ", default = (vim.b["conjure#client#guile#socket#pipename"] or default_socket), completion = "file"}, _10_)
  end
  return vim.api.nvim_buf_create_user_command(0, "GuileConnect", _9_, {})
elseif (ext == "ss") then
  return vim_b({{"conjure#client#scheme#stdio#command", "petite"}, {"conjure#client#scheme#stdio#prompt_pattern", "> $?"}, {"conjure#client#scheme#stdio#value_prefix_pattern", false}})
else
  return nil
end
