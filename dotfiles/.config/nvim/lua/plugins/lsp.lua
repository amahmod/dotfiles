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
            -- emmet_language_server = {
            --     filetypes = {
            --         'html',
            --         'css',
            --         'scss',
            --         'sass',
            --         'less',
            --         'javascriptreact',
            --         'typescriptreact',
            --         'vue',
            --         'svelte',
            --     },
            --     init_options = {
            --         ---@type table<string, string>
            --         includeLanguages = {},
            --         --- @type string[]
            --         excludeLanguages = {},
            --         --- @type string[]
            --         extensionsPath = {},
            --         --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
            --         preferences = {},
            --         --- @type boolean Defaults to `true`
            --         showAbbreviationSuggestions = true,
            --         --- @type "always" | "never" Defaults to `"always"`
            --         showExpandedAbbreviation = 'always',
            --         --- @type boolean Defaults to `false`
            --         showSuggestionsAsSnippets = false,
            --         --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
            --         syntaxProfiles = {},
            --         --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
            --         variables = {},
            --     },
            -- },
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
                                [vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy'] = true,
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
            vtsls = {
                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                {
                                    name = '@vue/typescript-plugin',
                                    location = vim.fn.stdpath 'data'
                                        .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                                    languages = { 'vue' },
                                    configNamespace = 'typescript',
                                },
                            },
                        },
                    },
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
            -- ts_ls = {
            --     root_dir = function(fname)
            --         local util = lspconfig.util
            --         return not util.root_pattern('deno.json', 'deno.jsonc')(fname)
            --             and util.root_pattern(
            --                 'tsconfig.json',
            --                 'package.json',
            --                 'jsconfig.json',
            --                 '.git'
            --             )(fname)
            --     end,
            --     init_options = {
            --         preferences = {
            --             includeCompletionsWithSnippetText = true,
            --             includeCompletionsForImportStatements = true,
            --         },
            --     },
            -- },
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
            vue_ls = {},
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
        }

        local function setup_keymaps(bufnr, client)
            local opts = { buffer = bufnr, silent = true }


            -- stylua: ignore start
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
                vim.lsp.buf.code_action {}
            end, opts)

            -- Diagnostics navigation
            vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, opts)
            vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end, opts)
            vim.keymap.set('n', '[e', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end, opts)
            vim.keymap.set('n', ']e', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end, opts)
            vim.keymap.set('n', '[w', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN } end, opts)
            vim.keymap.set('n', ']w', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN } end, opts)

            vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", "<leader>th", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hint (Global)" })

            -- TypeScript and Svelte specific keymaps
            -- if client.name == 'typescript-tools' or client.name == 'svelte' then
            --     vim.keymap.set('n', '<leader>to', '<cmd>TSToolsOrganizeImports<cr>', opts)
            --     vim.keymap.set('n', '<leader>ta', '<cmd>TSToolsAddMissingImports<cr>', opts)
            --     vim.keymap.set('n', '<leader>tr', '<cmd>TSToolsRemoveUnusedImports<cr>', opts)
            --     vim.keymap.set('n', '<leader>tf', '<cmd>TSToolsFixAll<cr>', opts)
            --     vim.keymap.set('n', '<leader>tR', '<cmd>TSToolsRenameFile<cr>', opts)
            -- end

            -- stylua: ignore end
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
                'vue_ls',
                'ts_ls',
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
            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        end

        -- Configure diagnostic display
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
