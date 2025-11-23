-- [nfnl] fnl/config/filetypes.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
vim.filetype.add({extension = {jk = "joker"}})
augroup("joker", {clear = true})
return autocmd({"FileType"}, {pattern = "joker", group = "joker", command = "runtime! indent/clojure.vim"})
