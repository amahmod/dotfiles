return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            flavour = 'macchiato',
            transparent_background = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
                fzf = true,
                mason = true,
                native_lsp = { enabled = true },
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
        end,
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
    },
    {
        'shaunsingh/nord.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.nord_disable_background = true
        end,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            transparent_mode = true,
        },
    },
    {
        dir = vim.fn.stdpath('config'),
        name = 'system-theme-loader',
        lazy = false,
        priority = 999,
        config = function()
            local theme_file = vim.fn.stdpath('config') .. '/lua/current_theme.lua'
            if vim.fn.filereadable(theme_file) == 1 then
                dofile(theme_file)
            else
                vim.cmd.colorscheme('catppuccin-macchiato')
            end
        end,
    },
}
