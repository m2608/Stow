{1 "dhruvasagar/vim-table-mode"
 :lazy true
 :cmd ["TableAddFormula"
       "TableEvalFormulaLine"
       "TableModeDisable"
       "TableModeEnable"
       "TableModeRealign"
       "TableModeToggle"
       "TableSort"
       "Tableize"]
:init (fn []
        (let [options [["table_mode_corner" "|"]
                       ["table_mode_header_fillchar" "-"]]]
          (each [_ option (ipairs options)]
            (let [name (. option 1)
                  value (. option 2)]
              (tset vim.g name value)))))}
