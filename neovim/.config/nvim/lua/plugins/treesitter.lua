-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  local ts_install = require("nvim-treesitter.install")
  return ts_install.update({with_sync = true})
end
local function _2_()
  do
    local ts_install = require("nvim-treesitter.install")
    local ts_configs = require("nvim-treesitter.configs")
    ts_install["compilers"] = {"clang"}
    ts_configs.setup({highlight = {enable = true, additional_vim_regex_highlighting = {"markdown"}}, indent = {enable = true}, playground = {enabled = true}, textobjects = {select = {enable = true, keymaps = {af = "@function.outer", ["if"] = "@function.inner"}}}})
  end
  return vim.treesitter.language.register("clojure", "joker")
end
return {"nvim-treesitter/nvim-treesitter", cond = ((1 == vim.fn.executable("clang")) and (1 == vim.fn.executable("tree-sitter"))), build = _1_, config = _2_}
