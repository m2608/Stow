(fn set-mapping [mode from to ...]
  (let [opts (if (= (length [...]) 0) {:noremap true :silent true}
               (. [...] 1))]
    (vim.keymap.set mode from to opts)))

{1 "nvim-treesitter/nvim-treesitter-textobjects"
 :branch "main"
 :dependencies ["nvim-treesitter/nvim-treesitter"]
 :init (fn []
         (tset vim.g "no_plugin_maps" true))
 :config (fn []
           (let [to (require "nvim-treesitter-textobjects")
                 s  (require "nvim-treesitter-textobjects.select")
                 m  (require "nvim-treesitter-textobjects.move")
                 mappings [[["x" "o"]     "am" (fn [] (s.select_textobject     "@function.outer" "textobjects"))]
                           [["x" "o"]     "im" (fn [] (s.select_textobject     "@function.inner" "textobjects"))]
                           [["x" "o"]     "ac" (fn [] (s.select_textobject     "@class.outer"    "textobjects"))]
                           [["x" "o"]     "ic" (fn [] (s.select_textobject     "@class.inner"    "textobjects"))]
                           [["n" "x" "o"] "]m" (fn [] (m.goto_next_start       "@function.outer" "textobjects"))]
                           [["n" "x" "o"] "[m" (fn [] (m.goto_previous_start   "@function.outer" "textobjects"))]
                           [["n" "x" "o"] "]M" (fn [] (m.goto_next_end         "@function.outer" "textobjects"))]
                           [["n" "x" "o"] "[M" (fn [] (m.goto_previous_end     "@function.outer" "textobjects"))]
                           [["n" "x" "o"] "]c" (fn [] (m.goto_next_start       "@class.outer"    "textobjects"))]
                           [["n" "x" "o"] "[c" (fn [] (m.goto_previous_start   "@class.outer"    "textobjects"))]
                           [["n" "x" "o"] "]C" (fn [] (m.goto_next_end         "@class.outer"    "textobjects"))]
                           [["n" "x" "o"] "[C" (fn [] (m.goto_previous_end     "@class.outer"    "textobjects"))]]]
             (each [_ mapping (ipairs mappings)]
               (set-mapping (unpack mapping)))))}
