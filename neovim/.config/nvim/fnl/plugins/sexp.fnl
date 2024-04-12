{1 "PaterJason/nvim-treesitter-sexp"
 :opts
 {;; Enable/disable
  :enabled true
  ;; Move cursor when applying commands
  :set_cursor true
  ;; Set to false to disable all keymaps
  :keymaps
  {;; Set to false to disable keymap type
   :commands
   {;; Set to false to disable individual keymaps
    :swap_prev_elem "<e"
    :swap_next_elem ">e"
    :swap_prev_form "<f"
    :swap_next_form ">f"
    :promote_elem   "<LocalLeader>O"
    :promote_form   "<LocalLeader>o"
    :splice         "<LocalLeader>@"
    :slurp_left     "<("
                       :slurp_right    ">)"
    :barf_left      ">("
                       :barf_right     "<)"
    :insert_head    "<I"
    :insert_tail    ">I"}
   :motions
   {:form_start     "("
                      :form_end       ")"
    :prev_elem      "[e"
                      :next_elem      "]e"
    :prev_elem_end  "[E"
                      :next_elem_end  "]E"
    :prev_top_level "[["
                       :next_top_level "]]"}
   :textobjects
   {:inner_elem      "ie"
    :outer_elem      "ae"
    :inner_form      "if"
    :outer_form      "af"
    :inner_top_level "iF"
    :outer_top_level "aF"}}}}
