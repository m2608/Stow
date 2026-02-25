-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local core = autoload("nfnl.core")
local function _2_()
  local function _3_()
    return vim.treesitter.start()
  end
  vim.api.nvim_create_autocmd({"FileType"}, {pattern = {"clojure"}, callback = _3_})
  local function _4_()
    vim.treesitter.start()
    vim.bo["indentexpr"] = "v:lua.require'nvim-treesitter'.indentexpr()"
    return nil
  end
  return vim.api.nvim_create_autocmd({"FileType"}, {pattern = {"joker", "fennel", "python"}, callback = _4_})
end
return {"nvim-treesitter/nvim-treesitter", cond = ((1 == vim.fn.executable("clang")) and (1 == vim.fn.executable("tree-sitter"))), build = ":TSUpdate", config = _2_}
