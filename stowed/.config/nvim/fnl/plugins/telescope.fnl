{1 "nvim-telescope/telescope.nvim"
 :tag "v0.2.1"
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
         :mappings {:i {"<C-y>" (. layout :toggle_preview)
                        "<C-b>" {1 "<left>"    :type "command"}
                        "<C-f>" {1 "<right>"   :type "command"}
                        "<M-b>" {1 "<S-left>"  :type "command"}
                        "<M-f>" {1 "<S-right>" :type "command"}
                        "<C-a>" {1 "<home>"    :type "command"}
                        "<C-e>" {1 "<end>"     :type "command"}
                        "<C-u>" false}
                    :n {"<C-y>" (. layout :toggle_preview)}}}

        :pickers
        {:buffers {:mappings {:n {"d" (. actions :delete_buffer)}}}
         :find_files {:no_ignore true :follow true :hidden true}}})))}
