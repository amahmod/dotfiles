---@type table<string, string[]>
local linters_by_ft = {
    javascript = { 'biomejs' },
    typescript = { 'biomejs' },
    javascriptreact = { 'biomejs' },
    typescriptreact = { 'biomejs' },
    json = { 'biomejs' },
    css = { 'biomejs' },
    python = { 'ruff', 'pylint' },
    lua = { 'luacheck' },
    sh = { 'shellcheck' },
    bash = { 'shellcheck' },
    zsh = { 'shellcheck' },
}

return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local lint = require 'lint'

        -- Configure linters
        lint.linters_by_ft = linters_by_ft

        -- Create lint autocommands
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

        local function should_lint(bufnr)
            if not vim.api.nvim_buf_is_loaded(bufnr) then
                return false
            end

            if vim.fn.wordcount().bytes > 1024 * 1024 then
                return false
            end

            local excluded_filetypes = {
                'help',
                'text',
                'gitcommit',
            }
            local ft = vim.bo[bufnr].filetype
            return not vim.tbl_contains(excluded_filetypes, ft)
        end

        local timer = (vim.uv or vim.loop).new_timer()
        local function debounced_lint(bufnr)
            if timer:is_active() then
                timer:stop()
            end
            timer:start(
                1000,
                0,
                vim.schedule_wrap(function()
                    if should_lint(bufnr) then
                        lint.try_lint(nil, { ignore_errors = true })
                    end
                end)
            )
        end

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
            group = lint_augroup,
            callback = function(args)
                debounced_lint(args.buf)
            end,
        })
    end,
}
