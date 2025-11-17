-- [nfnl] fnl/plugins/cmp.fnl
local core = require("nfnl.core")
local function _1_()
  local cmp = require("cmp")
  local function _2_(n)
    return {name = n}
  end
  local function _3_(fallback)
    if (cmp.visible() and cmp.get_selected_entry()) then
      cmp.abort()
      return vim.api.nvim_feedkeys(" ", "n", false)
    else
      return fallback()
    end
  end
  return cmp.setup({sources = cmp.config.sources(core.map(_2_, {"conjure", "nvim_lsp", "buffer", "latex_symbols"})), mapping = {["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<CR>"] = cmp.mapping.confirm({select = true}), ["<Space>"] = cmp.mapping(_3_, {"i", "s"})}})
end
return {"hrsh7th/nvim-cmp", dependencies = {{"hrsh7th/cmp-nvim-lsp", event = "LspAttach"}, {"PaterJason/cmp-conjure", ft = {"clojure", "edn"}, dependencies = {"Olical/conjure", lazy = true}}, {"kdheepak/cmp-latex-symbols"}}, lazy = true, event = {"InsertEnter"}, config = _1_}
