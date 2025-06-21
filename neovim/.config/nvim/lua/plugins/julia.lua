-- [nfnl] fnl/plugins/julia.fnl
local core = require("nfnl.core")
local function _1_()
  return core.assoc(vim.g, "latex_to_unicode_file_types", ".*")
end
return {"JuliaEditorSupport/julia-vim", config = _1_}
