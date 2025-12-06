-- [nfnl] fnl/plugins/conjure.fnl
local core = require("nfnl.core")
local filetypes = {"clojure", "fennel", "janet", "hy", "scheme", "lua", "lisp", "python", "janet", "joker"}
local function _1_()
  vim.g["conjure#filetypes"] = filetypes
  return nil
end
local function _2_()
  local options = {{"conjure#mapping#prefix", ","}, {"conjure#mapping#doc_word", "k"}, {"conjure#client#scheme#stdio#command", "petite"}, {"conjure#client#scheme#stdio#prompt_pattern", "> $?"}, {"conjure#client#scheme#stdio#value_prefix_pattern", false}, {"conjure#filetype#joker", "conjure.client.joker.stdio"}, {"conjure#client#python#stdio#command", "python3 -iq"}}
  for _, option in ipairs(options) do
    local k = option[1]
    local v = option[2]
    vim.g[k] = v
  end
  return nil
end
return {"Olical/conjure", ft = filetypes, init = _1_, config = _2_}
