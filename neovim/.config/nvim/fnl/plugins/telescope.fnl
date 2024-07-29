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
        {:preview {:check_mime_type true}
         :file_ignore_patterns {}
         :mappings {:i {"<C-y>" (. (require "telescope.actions.layout") :toggle_preview)}
                    :n {"<C-y>" (. (require "telescope.actions.layout") :toggle_preview)}}}

        :pickers
        {:buffers {:mappings {:n {"d" (. actions :delete_buffer)}}}}

        :extensions
        {:file_browser
         {:hijack_netrw true
          :grouped true
          :respect_gitignore false
          :follow_symlinks true
          :preview {:hide_on_startup true
                    :check_mime_type false}
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
