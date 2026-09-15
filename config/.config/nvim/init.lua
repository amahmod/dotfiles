vim.g.mapleader = ' '

local is_vscode = vim.g.vscode
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print 'Installing lazy.nvim plugin manager...'
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = {
        {
            import = 'plugins',
            cond = function()
                return not is_vscode
            end,
        },
    },
    rocks = {
        enabled = false,
    },
    change_detection = {
        notify = false,
    },
})

if not is_vscode then
    require 'options'
    require 'mappings'
    require 'autocmds'
end
