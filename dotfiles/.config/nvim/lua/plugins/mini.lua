return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.pairs').setup()
        require('mini.icons').setup()
        require('mini.surround').setup {
            mappings = {
                add = 'Sa',
                delete = 'Sd',
                find = 'Sf',
                find_left = 'SF',
                highlight = 'Sh',
                replace = 'Sr',
                update_n_lines = 'Sn',
            },
        }
        require('mini.splitjoin').setup {
            mappings = {
                toggle = 'gt',
                split = 'gs',
                join = 'gj',
            },
        }
    end,
}
