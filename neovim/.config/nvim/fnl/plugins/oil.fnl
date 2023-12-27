[{1 "stevearc/oil.nvim"
  :config
  (fn []
    (let [setup (. (require "oil") :setup)]
      (setup
        {:default_file_explorer false
         :columns ["icon"]})))}]
