{1 "nvim-telescope/telescope.nvim"
 :branch "0.1.x"
 :dependencies ["nvim-lua/plenary.nvim"]
 :config
 (fn []
   (let [setup      (. (require "telescope") :setup)
         actions    (require "telescope.actions")
         fb-actions (require "telescope._extensions.file_browser.actions")]
     (setup
       {:defaults
        {:preview {:check_mime_type false}
         :file_ignore_patterns {}}

        :pickers
        {:buffers {:mappings {:n {"d" (. actions :delete_buffer)}}}}

        :extensions
        {:file_browser
         {:hijack_netrw true
          :grouped true
          :respect_gitignore false
          :initial_mode "normal"
          :dir_icon " "
          :sorting_strategy "ascending"
          :mappings {:n {"." (. fb-actions :toggle_hidden)
                         "l" (. fb-actions :change_cwd)
                         "h" (. fb-actions :goto_parent_dir)
                         "~" (. fb-actions :goto_home_dir)
                         "e" (. fb-actions :open)
                         "c" (. fb-actions :copy)
                         "n" (. fb-actions :create)}}}}})))}
