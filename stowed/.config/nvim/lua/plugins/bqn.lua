-- [nfnl] fnl/plugins/bqn.fnl
local core = require("nfnl.core")
local function _1_(plugin)
  local plugin_dir = (plugin.dir .. "/editors/vim")
  return vim.opt.rtp:append(plugin_dir)
end
return {"mlochbaum/BQN", ft = "bqn", config = _1_, enabled = false, lazy = false}
