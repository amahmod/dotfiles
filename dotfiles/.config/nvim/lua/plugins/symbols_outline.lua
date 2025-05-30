return {
    'hedyhli/outline.nvim',
    cmd = { 'Outline' },
    keys = {
        { '<leader>to', '<cmd>Outline<CR>', desc = 'Symbols Outline' },
    },
    config = function()
        require('outline').setup {}
    end,
}
