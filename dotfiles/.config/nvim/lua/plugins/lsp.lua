return {
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'neovim/nvim-lspconfig',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'b0o/SchemaStore.nvim',
    },
    config = function()
        local servers = {
            emmet_language_server = {},
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
                        runtime = {
                            version = 'LuaJIT',
                            special = { reload = 'require' },
                        },
                        workspace = {
                            library = {
                                vim.fn.expand '$VIMRUNTIME/lua',
                                vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
                                vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
                            },
                        },
                        diagnostics = {
                            globals = {
                                'vim',
                                'use',
                                'describe',
                                'it',
                                'assert',
                                'before_each',
                                'after_each',
                            },
                        },
                    },
                },
            },
            denols = {
                root_dir = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc'),
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
            vtsls = {},
            ts_ls = {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
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
            svelte = {
                settings = {
                    svelte = {
                        enable = true,
                        diagnostics = {
                            enable = true,
                        },
                        format = {
                            enable = true,
                        },
                        plugin = {
                            svelte = {
                                defaultScriptLanguage = 'ts',
                            },
                        },
                        trace = {
                            server = 'off',
                        },
                        validate = {
                            enable = true,
                        },
                    },
                },
            },
            clangd = {
                settings = {
                    clangd = {
                        arguments = {
                            '--header-insertion=never',
                            '--clang-tidy',
                            '--all-scopes-completion',
                        },
                    },
                },
            },
        }

        local function setup_keymaps(bufnr, client)
            local opts = { buffer = bufnr, silent = true }

            -- Navigation
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

            -- Actions
            vim.keymap.set('n', '<leader>hd', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
                vim.lsp.buf.code_action {
                    context = { only = { 'source', 'refactor', 'quickfix' } },
                }
            end, opts)

            -- Diagnostics navigation
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '[e', function()
                vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
            end, opts)
            vim.keymap.set('n', ']e', function()
                vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
            end, opts)
            vim.keymap.set('n', '[w', function()
                vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
            end, opts)
            vim.keymap.set('n', ']w', function()
                vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
            end, opts)

            -- TypeScript and Svelte specific keymaps
            if client.name == 'typescript-tools' or client.name == 'svelte' then
                vim.keymap.set('n', '<leader>to', '<cmd>TSToolsOrganizeImports<cr>', opts)
                vim.keymap.set('n', '<leader>ta', '<cmd>TSToolsAddMissingImports<cr>', opts)
                vim.keymap.set('n', '<leader>tr', '<cmd>TSToolsRemoveUnusedImports<cr>', opts)
                vim.keymap.set('n', '<leader>tf', '<cmd>TSToolsFixAll<cr>', opts)
                vim.keymap.set('n', '<leader>tR', '<cmd>TSToolsRenameFile<cr>', opts)
            end
        end

        -- Setup mason-lspconfig
        require('mason-lspconfig').setup {
            -- Automatically install LSP servers
            ensure_installed = {
                'lua_ls',
                'html',
                'cssls',
                'tailwindcss',
                'jsonls',
                'yamlls',
                'eslint',
                'bashls',
                'rust_analyzer',
                'pyright',
                'gopls',
                'svelte',
                'templ',
                'vtsls',
                'ts_ls',
                'clangd',
                'emmet_language_server',
                'denols',
            },
            -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
            automatic_installation = true,
            automatic_enable = false,
        }

        -- Setup mason-tool-installer
        require('mason-tool-installer').setup {
            ensure_installed = {
                'stylua',
                'prettierd',
                'eslint_d',
                'black',
                'ruff',
                'rustfmt',
                'gofumpt',
                'goimports',
                'golines',
                'clang-format',
                'shfmt',
                'shellcheck',
            },
            auto_update = true,
            run_on_start = true,
        }

        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Add additional capabilities
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        for server_name, server_config in pairs(servers) do
            local config = vim.tbl_deep_extend('force', {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    setup_keymaps(bufnr, client)
                end,
            }, server_config)
            require('lspconfig')[server_name].setup(config)
        end

        -- Configure diagnostic display
        vim.diagnostic.config {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        }
    end,
}
