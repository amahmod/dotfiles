return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local parsers = {
            'bash',
            'css',
            'dockerfile',
            'gitcommit',
            'graphql',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'json5',
            'lua',
            'make',
            'markdown',
            'markdown_inline',
            'prisma',
            'query',
            'regex',
            'rust',
            'sql',
            'svelte',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
        }

        local ts = require 'nvim-treesitter'
        ts.setup {
            install_dir = vim.fn.stdpath 'data' .. '/site',
        }
        ts.install(parsers)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = parsers,
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
