-- [nfnl] fnl/plugins/chatgpt.fnl
local core = require("nfnl.core")
local function _1_()
  local chatgpt = require("chatgpt")
  local openai_proxy = os.getenv("OPENAI_PROXY")
  local openai_key_path = os.getenv("OPENAI_KEY_PATH")
  local openai_key_cmd = os.getenv("OPENAI_KEY_COMMAND")
  local openai_model = os.getenv("OPENAI_MODEL")
  local _2_
  if openai_proxy then
    _2_ = {extra_curl_params = {"-x", openai_proxy}}
  else
    _2_ = nil
  end
  local _4_
  if openai_key_path then
    _4_ = {api_key_cmd = ("gpg --quiet --batch --decrypt " .. openai_key_path)}
  else
    _4_ = nil
  end
  local function _6_()
    if openai_key_cmd then
      return {api_key_cmd = openai_key_cmd}
    else
      return nil
    end
  end
  return chatgpt.setup(core.merge({openai_params = {model = openai_model, frequency_penalty = 0, presence_penalty = 0, max_tokens = 1024, temperature = 0.7, top_p = 0.1, n = 1}}, _2_, _4_, _6_()))
end
return {"jackMort/ChatGPT.nvim", config = _1_, dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "folke/trouble.nvim", "nvim-telescope/telescope.nvim"}, cmd = {"ChatGPT", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions", "ChatGPTRun"}}
