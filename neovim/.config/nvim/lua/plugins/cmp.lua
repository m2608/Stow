-- [nfnl] fnl/plugins/cmp.fnl
local core = require("nfnl.core")
local function _1_()
  local cmp = require("cmp")
  local function _2_(n)
    return {name = n}
  end
  return cmp.setup({sources = cmp.config.sources(core.map(_2_, {"conjure", "nvim_lsp", "buffer"})), mapping = {["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<CR>"] = cmp.mapping.confirm({select = true}), ["<Esc>"] = cmp.mapping.abort()}})
end
return {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "PaterJason/cmp-conjure", "Olical/conjure"}, config = _1_}
