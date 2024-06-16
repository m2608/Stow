{1 "michaelb/sniprun"
 :branch "master"
 :build "sh install.sh 1"
 :config (fn []
           (let [sniprun (require "sniprun")]
             (sniprun.setup
               {:display
                ["TempFloatingWindow"]
                :interpreter_options
                {:Generic
                 {:error_truncate "long"
                  :chez
                  {:supported_filetypes "scheme"
                   :extension "*.scm"
                   :interpreter "chez-scheme -q"}}}
                :snipruncolors {:SniprunVirtualTextOk {}
                                :SniprunFloatingWinOk {}
                                :SniprunVirtualTextErr {}
                                :SniprunFloatingWinErr {}}})))}
