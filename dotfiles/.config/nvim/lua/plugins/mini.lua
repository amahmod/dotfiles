return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.pairs').setup()
        require('mini.icons').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup {
            mappings = {
                toggle = 'gS',
                split = 'gs',
                join = 'gj',
            },
        }
    end,
}
