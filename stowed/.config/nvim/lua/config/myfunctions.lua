-- [nfnl] fnl/config/myfunctions.fnl
module(myfunctions, {[autoload] = {[nvim] = "aniseed.nvim"}})
local function pipe_visual()
  local buf = vim.api.nvim_get_current_buf()
  local _let_1_ = vim.api.nvim_buf_get_mark(buf, "<")
  local sl = _let_1_[1]
  local sc = _let_1_[2]
  local _let_2_ = vim.api.nvim_buf_get_mark(buf, ">")
  local el = _let_2_[1]
  local ec = _let_2_[2]
  local lines = vim.api.nvim_buf_get_text(buf, (sl - 1), sc, (el - 1), (ec + 1), {})
  return print(sl, sc, el, ec, vim.inspect(lines))
end
local function f1(x)
  return print(x)
end
nvim.command(("command! -range -nargs=1 -complete=shellcmd Pipe " .. "call luaeval('require(\"config/myfunctions\")[\"f1\"](<f-args>)')"))
return {f1 = f1, ["pipe-visual"] = pipe_visual}
