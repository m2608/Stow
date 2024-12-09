{1 "nvim-telescope/telescope.nvim"
 :branch "0.1.x"
 :dependencies ["nvim-lua/plenary.nvim"]
 :config
 (fn []
   (let [telescope  (require "telescope")
         actions    (require "telescope.actions")
         layout     (require "telescope.actions.layout")
         fb-actions (require "telescope._extensions.file_browser.actions")]
     (telescope.setup
       {:defaults
        {:preview {:check_mime_type true}
         :file_ignore_patterns {}
         :mappings {:i {"<C-y>" (. layout :toggle_preview)}
                    :n {"<C-y>" (. layout :toggle_preview)}}}

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
          :cwd_to_path false
          :dir_icon " "
          :sorting_strategy "ascending"
          :mappings {:n {"." (. fb-actions :toggle_hidden)
                         "l" (. fb-actions :change_cwd)
                         "h" (. fb-actions :goto_parent_dir)
                         "~" (. fb-actions :goto_home_dir)
                         "e" (. fb-actions :open)
                         "c" (. fb-actions :copy)
                         "n" (. fb-actions :create)}}}}})
       ;; It is required to load "file_browser" to use netrw hijack just after
       ;; nvim start.
       (telescope.load_extension "file_browser")))}
