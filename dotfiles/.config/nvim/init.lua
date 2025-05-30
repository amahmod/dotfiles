vim.g.mapleader = ' '

local is_vscode = vim.g.vscode

if is_vscode then
    print("vscode")
else
    require "options"
    require "mappings"
    print("neovim")
end

