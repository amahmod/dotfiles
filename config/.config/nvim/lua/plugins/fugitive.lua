return {
    'tpope/vim-fugitive',
    cmd = {
        'Git',
        'G',
        'Gdiffsplit',
        'Gvdiffsplit',
        'Gwrite',
        'Gread',
        'Glog',
        'Gmove',
        'Gdelete',
    },
    keys = {
        { '<leader>gg', '<cmd>Git<cr>', desc = 'Vim Fugitive' },
    },
}
