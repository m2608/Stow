{1 "debugloop/telescope-undo.nvim"
 :dependencies ["nvim-telescope/telescope.nvim"]
 :config
 (fn [_ opts]
   (let [telescope (require "telescope")]
     (telescope.setup
       {:extensions
        {:undo
         {:use_delta false
          :initial_mode "normal"}}})
     (telescope.load_extension "undo")))}
