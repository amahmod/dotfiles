return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'echasnovski/mini.icons' },
    version = '*',
    opts = {
        keymap = {
            preset = 'super-tab',
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        signature = {
            enabled = true,
        },
        completion = {
            menu = {
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                return kind_icon
                            end,
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                    },
                },
            },
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            list = {
                max_items = 30,
            },
            accept = {
                auto_brackets = {
                    enabled = true,
                    kind_resolution = {
                        enabled = true,
                        blocked_filetypes = {
                            'typescriptreact',
                            'javascriptreact',
                            'vue',
                            'svelte',
                        },
                    },
                },
            },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    },
    opts_extend = { 'sources.default' },
}
