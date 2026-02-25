{1 "nvim-telescope/telescope.nvim"
 :tag "v0.2.1"
 :dependencies ["nvim-lua/plenary.nvim"
                "nvim-telescope/telescope-file-browser.nvim"
                "debugloop/telescope-undo.nvim"
                "Marskey/telescope-sg"]
 :config (fn []
           (let [telescope (require "telescope")
                 actions (require "telescope.actions")
                 layout (require "telescope.actions.layout")
                 fb-actions (require "telescope._extensions.file_browser.actions")]
             (telescope.setup {:defaults {:preview {:check_mime_type true}
                                          :file_ignore_patterns {}
                                          :mappings {:i {"<C-y>" (. layout
                                                                    :toggle_preview)
                                                         "<C-b>" {1 "<left>"
                                                                  :type "command"}
                                                         "<C-f>" {1 "<right>"
                                                                  :type "command"}
                                                         "<M-b>" {1 "<S-left>"
                                                                  :type "command"}
                                                         "<M-f>" {1 "<S-right>"
                                                                  :type "command"}
                                                         "<C-a>" {1 "<home>"
                                                                  :type "command"}
                                                         "<C-e>" {1 "<end>"
                                                                  :type "command"}
                                                         "<C-u>" false}
                                                     :n {"<C-y>" (. layout
                                                                    :toggle_preview)}}}
                               :pickers {:buffers {:mappings {:n {"d" (. actions
                                                                         :delete_buffer)}}}
                                         :find_files {:follow true
                                                      :disable_devicons true}}
                               :extensions {:file_browser {:hijack_netrw true
                                                           :grouped true
                                                           :respect_gitignore false
                                                           :follow_symlinks true
                                                           :preview {:hide_on_startup true
                                                                     :check_mime_type false}
                                                           :initial_mode "normal"
                                                           :dir_icon " "
                                                           :disable_devicons true
                                                           :sorting_strategy "ascending"
                                                           :mappings {:n {"." (. fb-actions
                                                                                 :toggle_hidden)
                                                                          "g" (. fb-actions
                                                                                 :toggle_respect_gitignore)
                                                                          "l" (. fb-actions
                                                                                 :open_dir)
                                                                          "h" (. fb-actions
                                                                                 :goto_parent_dir)
                                                                          "~" (. fb-actions
                                                                                 :goto_home_dir)
                                                                          "e" (. fb-actions
                                                                                 :open)
                                                                          "c" (. fb-actions
                                                                                 :copy)
                                                                          "n" (. fb-actions
                                                                                 :create)}}}
                                            :undo {:use_delta false
                                                   :initial_mode "normal"}
                                            :ast_grep {:command ["ast-grep"
                                                                 "--json=stream"]
                                                       :grep_open_files false
                                                       :lang nil}}})
             ;; It is required to load "file_browser" to use netrw hijack just after
             ;; nvim start.
             (telescope.load_extension "file_browser")
             (telescope.load_extension "undo")
             (telescope.load_extension "ast_grep")))}
