-- Если vim запущен из vscode, не загружаем конфиг.
if vim.g['vscode'] then
    local os = require('os')
    os.exit()
end

local execute = vim.api.nvim_command
local fn = vim.fn

-- Путь, куда мы будем сохранять плагины, где команда packadd сможет
-- их отыскать (см. :help packadd).
local pack_path = os.getenv("HOME") .. "/.nvim-pack"

-- Добавляем этот путь в packpath.
vim.o["packpath"] = vim.o["packpath"] .. "," .. pack_path

function ensure (repo, path)
    -- Функция проверяет, склонирован ли указанный репозиторий в указанный каталог.
    -- И если нужно - клонирует его, а потом загружает в vim.

    name = string.gsub(repo, "^.*/", "") 

    -- Путь, куда должен быть склонирован репозиторий.
    local install_path = string.format("%s/pack/plug/start/%s", path, name)

    if fn.empty(fn.glob(install_path)) > 0 then
        execute(string.format("!git clone https://github.com/%s %s", repo, install_path))
        execute(string.format("packadd %s", name))
    end
end

-- Загружаем плагины.
ensure("wbthomason/packer.nvim", pack_path)
ensure("Olical/aniseed", pack_path)
ensure("lewis6991/impatient.nvim", pack_path)

require("impatient")

-- Включаем автоматическую компиляцию в AniSeed.
vim.g["aniseed#env"] = {
    -- Грузим модуль init.fnl
    module = "init",
    compile = true
}
