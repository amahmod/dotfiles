return {
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'neovim/nvim-lspconfig',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'b0o/SchemaStore.nvim',
    },
    config = function()
        local servers = {
            biome = {}, -- Biome LSP for JS, TS, JSX, TSX, JSON, CSS
            gopls = {
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            },
            pyright = {
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = 'openFilesOnly',
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            },
            lua_ls = {
                server_capabilities = {
                    semanticTokensProvider = vim.NIL,
                },
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                                [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
                                [vim.fn.stdpath 'config' .. '/lua'] = true,
                            },
                        },
                    },
                },
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = '',
                        },
                        schemas = require('schemastore').yaml.schemas(),
                    },
                },
            },
            vtsls = {
                settings = {
                    javascript = {
                        updateImportsOnFileMove = { enabled = 'always' },
                    },
                    typescript = {
                        preferences = {
                            importModuleSpecifier = 'non-relative',
                            updateImportsOnFileMove = {
                                enabled = 'always',
                            },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = 'literals' },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                        },
                    },
                },
                filetypes = {
                    'typescript',
                    'javascript',
                    'javascriptreact',
                    'typescriptreact',
                    'vue',
                },
            },
            rust_analyzer = {
                settings = {
                    ['rust-analyzer'] = {
                        cargo = { allFeatures = true },
                        checkOnSave = {
                            command = 'clippy',
                            extraArgs = { '--no-deps' },
                        },
                    },
                },
            },
            svelte = {},
            bashls = {},
            html = {},
            cssls = {},
            tailwindcss = {},
        }

        local function setup_keymaps(bufnr, client)
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end

            -- Navigation
            map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to Definition')
            map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to Declaration')
            map('n', 'gT', vim.lsp.buf.type_definition, 'LSP: Go to Type Definition')
            map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover Documentation')
            map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to Implementation')
            map('n', 'gr', vim.lsp.buf.references, 'LSP: References')

            -- Actions
            map('n', '<leader>hd', vim.diagnostic.open_float, 'LSP: Show Line Diagnostics')
            map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename Symbol')
            map({ 'n', 'x' }, '<leader>ca', function()
                vim.lsp.buf.code_action {}
            end, 'LSP: Code Action')

            -- Diagnostics navigation
            map('n', '[d', function()
                vim.diagnostic.jump { count = -1 }
            end, 'LSP: Previous Diagnostic')
            map('n', ']d', function()
                vim.diagnostic.jump { count = 1 }
            end, 'LSP: Next Diagnostic')
            map('n', '[e', function()
                vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
            end, 'LSP: Previous Error')
            map('n', ']e', function()
                vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
            end, 'LSP: Next Error')
            map('n', '[w', function()
                vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN }
            end, 'LSP: Previous Warning')
            map('n', ']w', function()
                vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN }
            end, 'LSP: Next Warning')

            map('i', '<C-h>', function()
                vim.lsp.buf.signature_help()
            end, 'LSP: Signature Help')
            map('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, 'LSP: Toggle Inlay Hints')
        end

        -- Setup mason-lspconfig
        require('mason-lspconfig').setup {
            ensure_installed = {
                'biome',
                'lua_ls',
                'html',
                'cssls',
                'tailwindcss',
                'jsonls',
                'yamlls',
                'bashls',
                'rust_analyzer',
                'pyright',
                'gopls',
                'svelte',
                'vtsls',
            },
            automatic_installation = true,
            automatic_enable = false,
        }

        -- Setup mason-tool-installer
        require('mason-tool-installer').setup {
            ensure_installed = {
                'stylua',
                'biome',
                'black',
                'ruff',
                'gofumpt',
                'goimports',
                'shfmt',
                'shellcheck',
            },
            auto_update = true,
            run_on_start = true,
        }

        local capabilities = require('blink.cmp').get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        -- Neovim 0.12 Native LSP API: vim.lsp.config & vim.lsp.enable
        for server_name, server_config in pairs(servers) do
            local config = vim.tbl_deep_extend('force', {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    setup_keymaps(bufnr, client)
                end,
            }, server_config)
            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        end

        -- Configure diagnostic display (Neovim 0.12 API)
        vim.diagnostic.config {
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = ' ',
                    [vim.diagnostic.severity.WARN] = ' ',
                    [vim.diagnostic.severity.HINT] = '󰠠 ',
                    [vim.diagnostic.severity.INFO] = ' ',
                },
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = true,
                header = '',
                prefix = '',
            },
        }
    end,
}
