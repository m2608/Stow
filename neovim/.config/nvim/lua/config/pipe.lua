-- [nfnl] fnl/config/pipe.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = require("nfnl.core")
local str = require("nfnl.string")
local function pipe_lines(command, lines)
  local process = vim.system({"sh", "-c", command}, {text = true, stdin = table.concat(lines, "\n")})
  return str.split(core.get(process:wait(), "stdout"), "\n")
end
local function pipe_visual_lines(command)
  local _let_2_ = vim.api.nvim_buf_get_mark(0, "<")
  local sl = _let_2_[1]
  local _ = _let_2_[2]
  local _let_3_ = vim.api.nvim_buf_get_mark(0, ">")
  local el = _let_3_[1]
  local _0 = _let_3_[2]
  local lines = vim.api.nvim_buf_get_lines(0, (sl - 1), el, true)
  return vim.api.nvim_buf_set_lines(0, (sl - 1), el, true, pipe_lines(command, lines))
end
local function pipe_visual(command)
  local _let_4_ = vim.api.nvim_buf_get_mark(0, "<")
  local sl = _let_4_[1]
  local sc = _let_4_[2]
  local _let_5_ = vim.api.nvim_buf_get_mark(0, ">")
  local el = _let_5_[1]
  local ec = _let_5_[2]
  local lines = vim.api.nvim_buf_get_lines(0, (sl - 1), el, true)
  local pref = string.sub(core.first(lines), 1, sc)
  local post = string.sub(core.last(lines), (2 + ec))
  local function _6_(line)
    return string.sub(line, 1, (1 + ec))
  end
  core.update(lines, core.count(lines), _6_)
  local function _7_(line)
    return string.sub(line, (1 + sc))
  end
  core.update(lines, 1, _7_)
  local new_lines = pipe_lines(command, lines)
  local function _8_(line)
    return (pref .. line)
  end
  core.update(new_lines, 1, _8_)
  local function _9_(line)
    return (line .. post)
  end
  core.update(new_lines, core.count(new_lines), _9_)
  return vim.api.nvim_buf_set_lines(0, (sl - 1), el, true, new_lines)
end
local function pipe(command)
  local mode = vim.fn.visualmode()
  if (mode == "v") then
    return pipe_visual(command)
  elseif (mode == "V") then
    return pipe_visual_lines(command)
  else
    return nil
  end
end
local function _11_(opts)
  return pipe(opts.args)
end
vim.api.nvim_create_user_command("Pipe", _11_, {range = true, nargs = 1})
return vim.keymap.set("v", "|", ":Pipe ", {desc = "Pipe visual selection through shell command", silent = false})
