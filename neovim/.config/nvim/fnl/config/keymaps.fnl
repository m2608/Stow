(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local nvim (autoload "nvim"))

(fn set-mapping [mode from to ...]
  (let [opts (if (= (length [...]) 0) {:noremap true :silent true}
               (. [...] 1))]
    (nvim.set_keymap mode from to opts)))

(fn yank-for-quickfix
  []
  "Копирует ссылку на текущую позицию в виде строки для quickfix буфера."
  (let [filename (vim.fn.expand "%:.")
        [_ row column _ _] (vim.fn.getcurpos)]
    (vim.fn.setreg "" (.. filename ":" row ":" column ":" (vim.api.nvim_get_current_line)))))

(vim.keymap.set "n" "yq" yank-for-quickfix {:silent true :desc "Link for quickfix"})

(local mappings 
  [;; сохранить файл
   ["n" "<F2>" ":<c-u>update<CR>"]
   ;; вызов окна для навигации по коду (плагин tagbar)
   ["n" "<F8>" ":<c-u>TagbarToggle<CR>"]
   ;; вызов файлового браузера
   ["n" "<F9>" ":<c-u>NvimTreeToggle<CR>"]
   ;; забой убирает подсветку найденных фраз
   ["n" "<BS>" ":nohlsearch<CR>"]
   ;; комбинация выключает предупреждения линтера
   ["n" "<Leader><BS>" ":lua vim.diagnostic.hide()<CR>"]
   ;; используем пробел для сворачивания/разворачивания текущего блока
   ["n" "<space>" "za"]
   ;; комбинация для открытия файла из текущего каталога
   ["n" "<Leader>e" ":e <C-R>=expand(\"%:p:h\") . \"/\"<CR>" {:noremap true}]
   ;; комбинация для смены текущего каталога на каталог в котором лежит файл из
   ;; открытого буфера
   ["n" "<Leader>cd" ":lcd %:p:h<CR>:pwd<CR>" {:noremap true}]
   ;; следующее переназначение позволяет оставаться в визуальном режими при
   ;; интендации выделенного блока с помощью < и >
   ["v" "<" "<gv"]
   ["v" ">" ">gv"]
   ;; ctrl+space для автодополнения через omnifunc
   ["i" "<c-space>" "<c-x><c-o>"]
   ;; при дополнении по-умолчанию при выборе первого пункта с помощью кнопки Enter,
   ;; будет вставлен первый пункт и перевод строки, а при выборе любых других - только
   ;; вставлен пункт; чтобы сделать поведение всегда одинаковым нужно использовать
   ;; сочетание Ctrl+Y (см. :help popupmenu-keys); мы переназначим Enter таким образом,
   ;; чтобы, если открыто всплывающее меню, он посылал Ctrl+Y
   ["i" "<cr>" "pumvisible() ? \"<c-y>\" : \"<cr>\"" {:noremap true :silent true :expr true}]
   ;; копирует в буфер обмена от положения курсора до конца строки (по аналогии с
   ;; командами С и D)
   ["n" "Y" "y$"]
   ;; Перемещение между окнами по Ctrl+Tab и Ctrl+Shift+Tab. Для того, чтобы это работало,
   ;; нужно сделать биндинги в терминале (например, alacrirry поддерживает это).
   ["n" "<C-Tab>"   ":wincmd w<CR>"]
   ["n" "<C-S-Tab>" ":wincmd W<CR>"]
   ;; сочетания клавиш для режима вставки
   ["i" "<c-e>" "<c-o>$"]
   ["i" "<c-a>" "<c-o>^"]
   ;; сочетания клавиш для режима команд
   ["c" "<c-a>" "<home>"    {:noremap true}]
   ["c" "<c-e>" "<end>"     {:noremap true}]
   ["c" "<c-p>" "<up>"      {:noremap true}]
   ["c" "<c-n>" "<down>"    {:noremap true}]
   ["c" "<c-b>" "<left>"    {:noremap true}]
   ["c" "<c-f>" "<right>"   {:noremap true}]
   ["c" "<m-b>" "<s-left>"  {:noremap true}]
   ["c" "<m-f>" "<s-right>" {:noremap true}]
   ;; навигация по ошибкам
   ["n" "<c-j>" ":cn<CR>"]
   ["n" "<c-k>" ":cp<CR>"]
   ;; поиск слова под курсором по исходникам
   ["n" "<F3>" "yiw:vimgrep /<c-r>0/ **/*" {:noremap true}]
   ;; Открытие файла под курсором.
   ["n" "gx" ":silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>"]
   ["v" "gx" "y | :silent execute '!xdg-open ' . shellescape(expand(@\"), 1)<CR>"]
   ;; горячие клавиши для некоторых команд fzf
   ["n" "<Leader>ff" ":Telescope find_files<CR>"]
   ["n" "<Leader>fF" ":Telescope file_browser<CR>"]
   ["n" "<Leader>fb" ":Telescope buffers<CR>"]
   ["n" "<Leader>fg" ":Telescope live_grep<CR>"]
   ["n" "<Leader>fh" ":Telescope help_tags<CR>"]
   ["n" "<Leader>fe" ":Telescope diagnostics<CR>"]
   ["n" "<Leader>fs" ":Telescope lsp_document_symbols<CR>"]
   ["n" "<Leader>fr" ":Telescope lsp_references<CR>"]
   ["n" "<Leader>fd" ":Telescope lsp_definitions<CR>"]
   ["n" "<Leader>fG" ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>"]
   ;; горячие клавиши для Slime
   ["x" "<Leader>s" "<Plug>SlimeRegionSend" {:noremap false :silent true}]
   ["n" "<Leader>s" "<Plug>SlimeParagraphSend" {:noremap false :silent true}]
   ;; выход из режима вставки в терминале по Esc
   ["t" "<Esc>" "<C-\\><C-n>"]
   ;; OSCYank
   ["n" "<leader>y" "<Plug>OSCYankOperator" {:noremap false :silent true}]
   ["n" "<leader>yy" "<leader>y_" {:noremap false :silent true}]
   ["v" "<leader>y" "<Plug>OSCYankVisual" {:noremap false :silent true}]
   ;; lispdocs
   ["n" ",h" ":lua require('lispdocs').float({ fill = 0.8, win = { winblend = 0, cursorline = false }})<CR>"]])

(each [_ mapping (ipairs mappings)]
  (set-mapping (unpack mapping)))
