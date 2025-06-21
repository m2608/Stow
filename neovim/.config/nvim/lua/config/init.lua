-- [nfnl] fnl/config/init.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
require("config.settings")
require("config.commands")
require("config.autocmds")
require("config.keymaps")
return require("config.pipe")
