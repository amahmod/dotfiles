return {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        keywords = {
            FIX = {
                icon = ' ',
                color = 'error',
                alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
            },
            TODO = { icon = ' ', color = 'info' },
            HACK = { icon = ' ', color = 'warning', alt = { 'DON SKIP' } },
            WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
            PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
            NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'READ', 'COLORS' } },
            TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
        },
    },
    keys = {
        {
            ']t',
            function()
                require('todo-comments').jump_next()
            end,
            desc = 'Next todo comment',
        },
        {
            '[t',
            function()
                require('todo-comments').jump_prev()
            end,
            desc = 'Previous todo comment',
        },
    },
}
