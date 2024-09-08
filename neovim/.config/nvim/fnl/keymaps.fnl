(module keymaps
  {autoload
    {core :aniseed.core
     nvim :aniseed.nvim}})

(fn set-mapping [mode from to ...]
  (let [opts (if (= (length [...]) 0) {:noremap true :silent true}
               (. [...] 1))]
    (vim.keymap.set mode from to opts)))

(fn yank-for-quickfix
  []
  "Копирует ссылку на текущую позицию в виде строки для quickfix буфера."
  (let [filename (vim.fn.expand "%:.")
        [_ row column _ _] (vim.fn.getcurpos)]
    (vim.fn.setreg "" (.. filename ":" row ":" column ":" (vim.api.nvim_get_current_line)))))

(vim.keymap.set "n" "yq" yank-for-quickfix {:silent true :desc "Link for quickfix"})

(local mappings 
  [;; сохранить файл
   ["n" "<F2>" ":<C-u>update<CR>"]
   ["i" "<F2>" "<C-o>:update<CR>"]
   ;; вызов окна для навигации по коду (плагин tagbar)
   ; ["n" "<F8>" ":<C-u>TagbarToggle<CR>"]
   ["n" "<F8>" ":<C-u>Outline<CR>"]
   ;; вызов файлового браузера в каталоге с текущим файлом
   ["n" "<F9>" ":Telescope file_browser path=%:h<CR>"]
   ;; терминал
   ["n" "<F10>" ":ToggleTerm<CR>"]
   ;; включить режим без лишних панелей
   ["n" "<F11>" ":ZenMode<CR>"]
   ["n" "<F11>" "<C-o>:ZenMode<CR>"]
   ;; забой убирает подсветку найденных фраз
   ["n" "<BS>" ":nohlsearch<CR>"]
   ;; комбинация выключает предупреждения линтера
   ["n" "<Leader><BS>" ":lua vim.diagnostic.hide()<CR>"]
   ;; комбинация для открытия файла из текущего каталога
   ["n" "<Leader>e" ":e <C-R>=expand(\"%:p:h\") . \"/\"<CR>" {:noremap true}]
   ;; комбинация для смены текущего каталога на каталог в котором лежит файл из
   ;; открытого буфера
   ["n" "<Leader>cd" ":lcd %:p:h<CR>:pwd<CR>" {:noremap true}]
   ;; следующее переназначение позволяет оставаться в визуальном режими при
   ;; интендации выделенного блока с помощью < и >
   ["v" "<" "<gv"]
   ["v" ">" ">gv"]
   ;; если еще нет окна со списоком вариантов - Tab, если показываются варианты -
   ;; ходим по этому списку
   ["i" "<Tab>"   "pumvisible() ? \"<Down>\" : \"<Tab>\"" {:noremap true :silent true :expr true}]
   ["i" "<S-Tab>" "pumvisible() ? \"<Up>\"   : \"\""      {:noremap true :silent true :expr true}]
   ;; открываем окно с вариантами дополнения по C-n/C-p, по умолчанию эти сочетания открывают
   ;; окно с дополнением по ключевым словам - им я не пользуюсь
   ["i" "<C-n>"   "pumvisible() ? \"<Down>\" : \"<C-x><C-o>\"" {:noremap true :silent true :expr true}]
   ["i" "<C-p>"   "pumvisible() ? \"<Up\"    : \"<C-x><C-o>\"" {:noremap true :silent true :expr true}]
   ;; при дополнении по-умолчанию при выборе первого пункта с помощью кнопки Enter,
   ;; будет вставлен первый пункт и перевод строки, а при выборе любых других - только
   ;; вставлен пункт; чтобы сделать поведение всегда одинаковым нужно использовать
   ;; сочетание Ctrl+Y (см. :help popupmenu-keys); мы переназначим Enter таким образом,
   ;; чтобы, если открыто всплывающее меню, он посылал Ctrl+Y
   ["i" "<CR>" "pumvisible() ? \"<c-y>\" : \"<cr>\"" {:noremap true :silent true :expr true}]
   ;; копирует в буфер обмена от положения курсора до конца строки (по аналогии с
   ;; командами С и D)
   ["n" "Y" "y$"]
   ;; Перемещение между окнами по Ctrl+Tab и Ctrl+Shift+Tab. Для того, чтобы это работало,
   ;; нужно сделать биндинги в терминале (например, alacrirry поддерживает это).
   ["n" "<C-Tab>"   ":wincmd w<CR>"]
   ["n" "<C-S-Tab>" ":wincmd W<CR>"]
   ;; дополнительные сочетания для нормального режима
   ["n" "gh" "^"]
   ["n" "gl" "$"]
   ["n" "<m-x>" ":" {:noremap true :silent false}]
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
   ;; горячие клавиши для некоторых команд telescope
   ["n" "<space>f" ":Telescope find_files<CR>"]
   ["n" "<space>F" ":Telescope file_browser<CR>"]
   ["n" "<space>b" ":Telescope buffers<CR>"]
   ["n" "<space>/" ":Telescope live_grep<CR>"]
   ["n" "<space>g" ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>"]
   ["n" "<space>d" ":Telescope diagnostics<CR>"]
   ["n" "<space>s" ":Telescope lsp_document_symbols<CR>"]
   ["n" "<space>r" ":Telescope lsp_references<CR>"]
   ["n" "<space>j" ":Telescope jumplist<CR>"]

   ["n" "<Leader>fh" ":Telescope help_tags<CR>"]
   ["n" "<Leader>fd" ":Telescope lsp_definitions<CR>"]
   ;; горячие клавиши для Slime
   ["x" "<Leader>s" "<Plug>SlimeRegionSend" {:noremap false :silent true}]
   ["n" "<Leader>s" "<Plug>SlimeParagraphSend" {:noremap false :silent true}]
   ;; выход из режима вставки в терминале по Esc
   ["t" "<Esc>" "<C-\\><C-n>"]
   ;; OSCYank
   ["n" "<space>y" ":OSCYankOperator<CR>" {:noremap false :silent true}]
   ["v" "<space>y" ":OSCYankVisual<CR>"   {:noremap false :silent true}]
   ;; paste from system clipboard
   ["n" "<space>p" "\"+p"]
   ["n" "<space>P" "\"+P"]
   ;; lispdocs
   ["n" "<leader>h" ":lua require('lispdocs').float({ fill = 0.8, win = { winblend = 0, cursorline = false }})<CR>"]
   ["n" "<leader>d" ":lua require('nvim-devdocs.init').open_doc_current_file(true)<CR>"]])


(each [_ mapping (ipairs mappings)]
  (set-mapping (unpack mapping)))
