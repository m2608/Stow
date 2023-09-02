-- Если vim запущен из vscode, не загружаем конфиг.
if vim.g["vscode"] then
    return
end

local execute = vim.api.nvim_command
local fn = vim.fn

function ensure (repo, branch)
    -- Функция проверяет, склонирован ли указанный репозиторий в указанный каталог.
    -- И если нужно - клонирует его, а потом загружает в vim.

    name = string.gsub(repo, "^.*/", "") 

    -- Путь, куда должен быть склонирован репозиторий.
    local install_path = vim.fn.stdpath("data") .. "/lazy/" .. name

    if not vim.loop.fs_stat(install_path) then
        print("Cloning " .. repo .. " to " .. install_path .. "...")

        command = {"git", "clone", "--filter=blob:none", "https://github.com/" .. repo}
        if branch then
            table.insert(command, "--branch=" .. branch)
	end
        table.insert(command, install_path)

        vim.fn.system(command)
    end
    vim.opt.rtp:prepend(install_path)
end

vim.loader.enable()

-- Загружаем плагины.
ensure("folke/lazy.nvim", "stable")
ensure("Olical/aniseed")

-- Включаем автоматическую компиляцию в AniSeed.
vim.g["aniseed#env"] = {
    -- Грузим модуль init.fnl
    module = "init",
    compile = true
}
