local _2afile_2a = "/usr/home/undume/.config/nvim/fnl/plugins.fnl"
local _2amodule_name_2a = "plugins"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local core, nvim, packer = autoload("aniseed.core"), autoload("aniseed.nvim"), autoload("packer")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["packer"] = packer
local function load_plugins(plugins)
  local function _1_(use)
    for _, plugin in ipairs(plugins) do
      local value_type = type(plugin)
      local function _2_()
        if (value_type == "string") then
          return plugin
        elseif (value_type == "table") then
          local name = plugin[1]
          local opts = plugin[2]
          return core.assoc(opts, 1, name)
        else
          return nil
        end
      end
      use(_2_())
    end
    return nil
  end
  return packer.startup(_1_)
end
_2amodule_2a["load-plugins"] = load_plugins
local function _3_()
  return nvim.fn["firenvim#install"]()
end
load_plugins({"tpope/vim-surround", "godlygeek/tabular", "neovim/nvim-lspconfig", "kyazdani42/nvim-tree.lua", {"nvim-telescope/telescope.nvim", {branch = "0.1.x", requires = {"nvim-lua/plenary.nvim"}}}, "tomtom/tcomment_vim", "preservim/tagbar", "jpalardy/vim-slime", "Olical/conjure", {"clojure-vim/vim-jack-in", {requires = {"tpope/vim-dispatch", "radenling/vim-dispatch-neovim"}}}, "kien/rainbow_parentheses.vim", "bakpakin/fennel.vim", "fourjay/vim-hurl", "tpope/vim-fugitive", "skywind3000/asyncrun.vim", "ojroques/vim-oscyank", {"glacambre/firenvim", {run = _3_}}})
core.assoc(nvim.g, "tagbar_ctags_bin", "/usr/local/bin/uctags")
core.assoc(nvim.g, "conjure#mapping#prefix", ",")
core.assoc(nvim.g, "conjure#client#fennel#aniseed#aniseed_module_prefix", "aniseed.")
core.assoc(nvim.g, "conjure#client#scheme#stdio#command", "petite")
core.assoc(nvim.g, "conjure#client#scheme#stdio#prompt_pattern", "> $?")
core.assoc(nvim.g, "conjure#client#scheme#stdio#value_prefix_pattern", false)
do
  local nvim_tree = require("nvim-tree")
  nvim_tree.setup({update_focused_file = {enable = true, update_cwd = true}, renderer = {icons = {show = {git = false, folder = true, file = false, folder_arrow = false}}}})
end
core.assoc(nvim.g, "slime_target", "tmux")
core.assoc(nvim.g, "slime_paste_file", "$HOME/.slime_paste")
core.assoc(nvim.g, "slime_default_config", {socket_name = "default", target_pane = "{last}"})
core.assoc(nvim.g, "slime_dont_ask_default", 1)
core.assoc(nvim.g, "firenvim_config", {globalSettings = {alt = "all"}, localSettings = {[".*"] = {cmdline = "neovim", content = "text", priority = 0, selector = "textarea", takeover = "never"}}})
return _2amodule_2a