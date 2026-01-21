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
        {:buffers {:mappings {:n {"d" (. actions :delete_buffer)}}}
         :find_files {:no_ignore true}}})))}
