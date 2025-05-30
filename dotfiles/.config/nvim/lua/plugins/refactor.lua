return {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('refactoring').setup {}

        -- stylua: ignore start
        -- Main refactoring menu
        vim.keymap.set({ 'n', 'x' }, '<leader>rr', function() require('refactoring').select_refactor() end, { desc = "Open [R]efactor Menu"})
        
        -- Extract operations
        vim.keymap.set({ "n", "x" }, "<leader>re", function() return require('refactoring').refactor('Extract Function') end, { expr = true, desc = '[R]efactor [E]xtract function' })
        vim.keymap.set({ "n", "x" }, "<leader>rf", function() return require('refactoring').refactor('Extract Function To File') end, { expr = true, desc = '[R]efactor [F]unction to file' })
        vim.keymap.set({ "n", "x" }, "<leader>rv", function() return require('refactoring').refactor('Extract Variable') end, { expr = true, desc = '[R]efactor [V]ariable' })
        
        -- Inline operations
        vim.keymap.set({ "n", "x" }, "<leader>ri", function() return require('refactoring').refactor('Inline Variable') end, { expr = true, desc = '[R]efactor [I]nline variable' })
        vim.keymap.set({ "n", "x" }, "<leader>rI", function() return require('refactoring').refactor('Inline Function') end, { expr = true, desc = '[R]efactor [I]nline function' })
        
        -- Block operations
        vim.keymap.set({ "n", "x" }, "<leader>rbb", function() return require('refactoring').refactor('Extract Block') end, { expr = true, desc = '[R]efactor [B]lock' })
        vim.keymap.set({ "n", "x" }, "<leader>rbf", function() return require('refactoring').refactor('Extract Block To File') end, { expr = true, desc = '[R]efactor [B]lock to file' })
        
        -- Debug operations
        vim.keymap.set({ 'x', 'n' }, '<leader>rd', function() require('refactoring').debug.print_var() end, { desc = '[R]efactor [D]ebug print variable' })
        -- stylua: ignore end
    end,
}
