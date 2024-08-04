(local core (require "aniseed.core"))

{1 "jackMort/ChatGPT.nvim"
 :config
 (fn []
   (let [chatgpt (require "chatgpt")
         openai-proxy    (os.getenv "OPENAI_PROXY")
         openai-key-path (os.getenv "OPENAI_KEY_PATH")
         openai-model    (os.getenv "OPENAI_MODEL")]
     (chatgpt.setup
       (core.merge
       {:openai_params {:model openai-model
                        :frequency_penalty 0
                        :presence_penalty 0
                        :max_tokens 1024
                        :temperature 0.7
                        :top_p 0.1
                        :n 1}}
       (when openai-proxy
         {:extra_curl_params ["-x" openai-proxy]})
       (when openai-key-path
         {:api_key_cmd (.. "gpg --quiet --batch --decrypt " openai-key-path)})))))
 :dependencies ["MunifTanjim/nui.nvim"
                "nvim-lua/plenary.nvim"
                "folke/trouble.nvim"
                "nvim-telescope/telescope.nvim"]
 :cmd ["ChatGPT" "ChatGPTActAs" "ChatGPTCompleteCode" "ChatGPTEditWithInstructions" "ChatGPTRun"]}
