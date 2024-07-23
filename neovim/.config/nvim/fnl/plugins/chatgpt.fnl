{1 "jackMort/ChatGPT.nvim"
 :config
 (fn []
   (let [chatgpt (require "chatgpt")
         proxy (os.getenv "CHATGPT_PROXY")
         api-key-path (.. (os.getenv "HOME") "/.password-store/chatgpt/gpt-4o.gpg")]
     (chatgpt.setup
       {:api_key_cmd (.. "gpg --quiet --batch --decrypt " api-key-path)
        :extra_curl_params (when proxy
                             ["-x" proxy])
        :openai_params {:model "gpt-4o"
                        :frequency_penalty 0
                        :presence_penalty 0
                        :max_tokens 1024
                        :temperature 0.7
                        :top_p 0.1
                        :n 1}})))
 :dependencies ["MunifTanjim/nui.nvim"
                "nvim-lua/plenary.nvim"
                "folke/trouble.nvim"
                "nvim-telescope/telescope.nvim"]
 :cmd ["ChatGPT" "ChatGPTActAs" "ChatGPTCompleteCode" "ChatGPTEditWithInstructions" "ChatGPTRun"]}
