-- [nfnl] fnl/plugins/slime.fnl
local function _1_()
  local options = {{"slime_target", "tmux"}, {"slime_default_config", {socket_name = "default", target_pane = "{last}"}}, {"slime_dont_ask_default", 1}}
  for _, _2_ in ipairs(options) do
    local k = _2_[1]
    local v = _2_[2]
    vim.g[k] = v
  end
  return nil
end
return {"jpalardy/vim-slime", lazy = true, config = _1_, cmd = {"SlimeConfig", "SlimeSend", "SlimeSend0", "SlimeSend1", "SlimeSendCurrentLine", "SlimeRegionSend"}}
