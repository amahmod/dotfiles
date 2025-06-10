return {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('tokyonight').setup {
            style = 'night',
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = { italic = true, bold = true },
                variables = { italic = false },
            },
            on_highlights = function(hl, colors)
                hl.LineNrAbove = { fg = colors.dark5 }
                hl.LineNrBelow = { fg = colors.dark5 }
            end,
        }

        vim.cmd [[colorscheme tokyonight]] -- tokyonight-night, tokyonight-day, tokyonight-moon, tokyonight-storm
    end,
}
