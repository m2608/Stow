[{1 "nvim-telescope/telescope.nvim"
  :branch "0.1.x"
  :dependencies ["nvim-lua/plenary.nvim"]
  :config
  (fn []
    (let [setup (. (require "telescope") :setup)
          delete_buffer (. (require "telescope.actions") :delete_buffer)]
      (setup
        {:defaults
         {:preview {:check_mime_type false}
          :mappings {:n {"d" delete_buffer}}}
         :extensions
         {:file_browser
          {:hijack_netrw true
           :grouped true
           :dir_icon " "
           :sorting_strategy "ascending"}}})))}]
