{1 "williamboman/mason.nvim"
 :lazy (not= (vim.fn.trim (vim.fn.system "uname")) "Linux")
 :config (fn []
           (let [setup (. (require "mason") :setup)]
             (setup)))}
