return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            flavour = 'macchiato',
            transparent_background = false,
            integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
                fzf = true,
                mason = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { 'italic' },
                        hints = { 'italic' },
                        warnings = { 'italic' },
                        information = { 'italic' },
                    },
                    underlines = {
                        errors = { 'underline' },
                        hints = { 'underline' },
                        warnings = { 'underline' },
                        information = { 'underline' },
                    },
                },
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
            vim.cmd.colorscheme 'catppuccin'
        end,
    },
}
