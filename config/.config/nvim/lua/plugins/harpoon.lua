return {
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = {
            'BufReadPost',
            'BufNewFile',
        },
        keys = {
            {
                '<C-S-M>',
                function()
                    require('harpoon.ui').toggle_quick_menu()
                end,
                desc = 'Harpoon Quick Menu',
            },
            {
                '<C-m>',
                function()
                    require('harpoon.mark').add_file()
                end,
                desc = 'Harpoon File 1',
            },
            {
                '<leader>1',
                function()
                    require('harpoon.ui').nav_file(1)
                end,
                desc = 'Harpoon File 1',
            },
            {
                '<leader>2',
                function()
                    require('harpoon.ui').nav_file(2)
                end,
                desc = 'Harpoon File 2',
            },
            {
                '<leader>3',
                function()
                    require('harpoon.ui').nav_file(3)
                end,
                desc = 'Harpoon File 3',
            },
            {
                '<leader>4',
                function()
                    require('harpoon.ui').nav_file(4)
                end,
                desc = 'Harpoon File 4',
            },
        },
        config = function()
            require('harpoon').setup {
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                    enter_on_sendcmd = false,
                    tmux_autoclose_windows = false,
                    excluded_filetypes = { 'harpoon' },
                    mark_branch = false,
                },
            }
        end,
    },
}
