-- [nfnl] fnl/plugins/firenvim.fnl
local core = require("nfnl.core")
local function _1_()
  return vim.fn["firenvim#install"](0)
end
local function _2_()
  return core.assoc(vim.g, "firenvim_config", {globalSettings = {alt = "all"}, localSettings = {[".*"] = {cmdline = "neovim", content = "text", priority = 0, selector = "textarea", takeover = "never"}}})
end
return {"glacambre/firenvim", lazy = not vim.g.started_by_firenvim, build = _1_, config = _2_}
