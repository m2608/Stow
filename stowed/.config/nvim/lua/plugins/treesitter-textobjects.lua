-- [nfnl] fnl/plugins/treesitter-textobjects.fnl
local function set_mapping(mode, from, to, ...)
  local opts
  if (#{...} == 0) then
    opts = {noremap = true, silent = true}
  else
    opts = ({...})[1]
  end
  return vim.keymap.set(mode, from, to, opts)
end
local function _2_()
  vim.g["no_plugin_maps"] = true
  return nil
end
local function _3_()
  local to = require("nvim-treesitter-textobjects")
  local s = require("nvim-treesitter-textobjects.select")
  local m = require("nvim-treesitter-textobjects.move")
  local mappings
  local function _4_()
    return s.select_textobject("@function.outer", "textobjects")
  end
  local function _5_()
    return s.select_textobject("@function.inner", "textobjects")
  end
  local function _6_()
    return s.select_textobject("@class.outer", "textobjects")
  end
  local function _7_()
    return s.select_textobject("@class.inner", "textobjects")
  end
  local function _8_()
    return m.goto_next_start("@function.outer", "textobjects")
  end
  local function _9_()
    return m.goto_previous_start("@function.outer", "textobjects")
  end
  local function _10_()
    return m.goto_next_end("@function.outer", "textobjects")
  end
  local function _11_()
    return m.goto_previous_end("@function.outer", "textobjects")
  end
  local function _12_()
    return m.goto_next_start("@class.outer", "textobjects")
  end
  local function _13_()
    return m.goto_previous_start("@class.outer", "textobjects")
  end
  local function _14_()
    return m.goto_next_end("@class.outer", "textobjects")
  end
  local function _15_()
    return m.goto_previous_end("@class.outer", "textobjects")
  end
  mappings = {{{"x", "o"}, "am", _4_}, {{"x", "o"}, "im", _5_}, {{"x", "o"}, "ac", _6_}, {{"x", "o"}, "ic", _7_}, {{"n", "x", "o"}, "]m", _8_}, {{"n", "x", "o"}, "[m", _9_}, {{"n", "x", "o"}, "]M", _10_}, {{"n", "x", "o"}, "[M", _11_}, {{"n", "x", "o"}, "]c", _12_}, {{"n", "x", "o"}, "[c", _13_}, {{"n", "x", "o"}, "]C", _14_}, {{"n", "x", "o"}, "[C", _15_}}
  for _, mapping in ipairs(mappings) do
    set_mapping(unpack(mapping))
  end
  return nil
end
return {"nvim-treesitter/nvim-treesitter-textobjects", branch = "main", dependencies = {"nvim-treesitter/nvim-treesitter"}, init = _2_, config = _3_}
