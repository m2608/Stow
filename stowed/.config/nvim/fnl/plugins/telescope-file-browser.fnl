{1 "nvim-telescope/telescope-file-browser.nvim"
 :dependencies ["nvim-telescope/telescope.nvim"]
 :config
 (fn [_ opts]
   (let [telescope (require "telescope")
         fb-actions (require "telescope._extensions.file_browser.actions")]
     (telescope.setup {:extensions
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
                                        "l" (. fb-actions :open_dir)
                                        "h" (. fb-actions :goto_parent_dir)
                                        "~" (. fb-actions :goto_home_dir)
                                        "e" (. fb-actions :open)
                                        "c" (. fb-actions :copy)
                                        "n" (. fb-actions :create)}}}}})
     ;; It is required to load "file_browser" to use netrw hijack just after
     ;; nvim start.
     (telescope.load_extension "file_browser")))}
