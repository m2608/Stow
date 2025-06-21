-- [nfnl] fnl/config/plugins.fnl
module(plugins, {[autoload] = {[nvim] = aniseed.nvim, [core] = aniseed.core, [fs] = aniseed.fs}})
local function _1_(path)
  return require(string.gsub(path, "^/(.*)[.]fnl$", "plugins.%1"))
end
return require("lazy").setup(core.map(_1_, fs.relglob((vim.fn.stdpath("config") .. "/fnl/plugins"), "*.fnl")))
