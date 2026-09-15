local auto_format_on_save = true

local biome_config = {
    'biome-check',
    'biome',
    stop_after_first = true,
}

return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>lf',
            function()
                require('conform').format {
                    async = true,
                    lsp_fallback = true,
                    timeout_ms = 3000,
                }
            end,
            mode = { 'n', 'v' },
            desc = 'Format buffer',
        },
    },
    opts = {
        -- Define formatters using Biome instead of Prettier/ESLint
        formatters_by_ft = {
            lua = { 'stylua' },
            javascript = biome_config,
            typescript = biome_config,
            javascriptreact = biome_config,
            typescriptreact = biome_config,
            svelte = { 'biome', 'prettier' },
            css = biome_config,
            html = { 'biome' },
            json = biome_config,
            jsonc = biome_config,
            yaml = { 'biome' },
            graphql = biome_config,
            python = { 'ruff_format', 'black' },
            go = { 'gofmt', 'goimports' },
            rust = { 'rustfmt' },
            sh = { 'shfmt' },
            zsh = { 'shfmt' },
            bash = { 'shfmt' },
        },

        -- Customize formatters
        formatters = {
            shfmt = {
                prepend_args = { '-i', '2', '-ci' },
            },
            black = {
                prepend_args = { '--fast', '--line-length=88' },
            },
        },

        -- Format on save options
        format_on_save = auto_format_on_save and {
            timeout_ms = 3000,
            lsp_fallback = true,
            async = false,
        } or nil,

        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
