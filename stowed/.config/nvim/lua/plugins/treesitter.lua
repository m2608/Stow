-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  do
    local ts = require("nvim-treesitter")
    ts.setup({highlight = {enable = true, additional_vim_regex_highlighting = {"markdown"}}, indent = {enable = true}, textobjects = {select = {enable = true, keymaps = {af = "@function.outer", ["if"] = "@function.inner"}}}})
  end
  return vim.treesitter.language.register("clojure", "joker")
end
return {"nvim-treesitter/nvim-treesitter", cond = ((1 == vim.fn.executable("clang")) and (1 == vim.fn.executable("tree-sitter"))), build = ":TSUpdate", config = _1_}
