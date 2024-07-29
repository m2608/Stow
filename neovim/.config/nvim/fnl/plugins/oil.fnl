{1 "stevearc/oil.nvim"
 :lazy true
 :config
 (fn []
   (let [setup (. (require "oil") :setup)]
     (setup
       {:default_file_explorer false
        :columns ["icon"]})))
 :cmd ["Oil"]}
