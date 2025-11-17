-- [nfnl] fnl/plugins/table-mode.fnl
local function _1_()
  local options = {{"table_mode_corner", "|"}, {"table_mode_header_fillchar", "-"}}
  for _, option in ipairs(options) do
    local name = option[1]
    local value = option[2]
    vim.g[name] = value
  end
  return nil
end
return {"dhruvasagar/vim-table-mode", lazy = true, cmd = {"TableAddFormula", "TableEvalFormulaLine", "TableModeDisable", "TableModeEnable", "TableModeRealign", "TableModeToggle", "TableSort", "Tableize"}, init = _1_}
