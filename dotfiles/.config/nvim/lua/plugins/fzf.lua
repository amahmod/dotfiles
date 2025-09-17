return {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
        -- stylua: ignore start
        -- File Operations (prefix: <leader>f)
        { '<C-p>', function() require('fzf-lua').files() end, desc = 'Find files' },
        { '<leader>ff', function() require('fzf-lua').files() end, desc = 'Find files' },
        { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'Recent files' },
        { '<leader>fd', function() require('fzf-lua').files({ cwd = vim.fn.stdpath("config") }) end, desc = 'Find dotfiles' },
        { '<leader>fs', function() require('fzf-lua').files({ cwd = vim.fn.getcwd() }) end, desc = 'Find files in cwd' },
        { '<leader>fz', function() require('fzf-lua').resume() end, desc = 'Resume last search' },

        -- Search and Navigation (prefix: <leader>s)
        { '<leader>sf', function() require('fzf-lua').live_grep() end, desc = 'Live grep' },
        { '<leader>sb', function() require('fzf-lua').buffers() end, desc = 'Find buffers' },
        { '<leader>st', function() require('fzf-lua').tabs() end, desc = 'Find tabs' },
        { '<leader>sw', function() require('fzf-lua').grep_cword() end, desc = 'Grep current word' },
        { '<leader>sl', function() require('fzf-lua').blines() end, desc = 'Search in current buffer' },

        -- Git Operations (prefix: <leader>g)
        { '<leader>gf', function() require('fzf-lua').git_files() end, desc = 'Git files' },
        { '<leader>gb', function() require('fzf-lua').git_branches() end, desc = 'Git branches' },
        { '<leader>gc', function() require('fzf-lua').git_commits() end, desc = 'Git commits' },
        { '<leader>gs', function() require('fzf-lua').git_status() end, desc = 'Git status' },
        { '<leader>gl', function() require('fzf-lua').git_stash() end, desc = 'Git stash' },

        -- Vim Features (prefix: <leader>v)
        { '<leader>vm', function() require('fzf-lua').marks() end, desc = 'Find marks' },
        { '<leader>vr', function() require('fzf-lua').registers() end, desc = 'Find registers' },
        { '<leader>vk', function() require('fzf-lua').keymaps() end, desc = 'Find keymaps' },
        { '<leader>vc', function() require('fzf-lua').commands() end, desc = 'Find commands' },
        { '<leader>/', function() require('fzf-lua').search_history() end, desc = 'Search history' },
        { '<leader>:', function() require('fzf-lua').command_history() end, desc = 'Command history' },

        -- Diagnostics and Lists (prefix: <leader>d)
        { '<leader>dd', function() require('fzf-lua').diagnostics_document() end, desc = 'Document diagnostics' },
        { '<leader>dw', function() require('fzf-lua').diagnostics_workspace() end, desc = 'Workspace diagnostics' },
        { '<leader>dl', function() require('fzf-lua').loclist() end, desc = 'Location list' },
        { '<leader>dq', function() require('fzf-lua').quickfix() end, desc = 'Quickfix list' },

        -- Help and Utilities (prefix: <leader>h)
        { '<leader>hh', function() require('fzf-lua').help_tags() end, desc = 'Find help tags' },
        { '<leader>hs', function() require('fzf-lua').spell_suggest() end, desc = 'Spell suggestions' },
        { '<leader>ht', function() require('fzf-lua').colorschemes() end, desc = 'Find colorschemes' },
        { '<leader>hm', function() require('fzf-lua').man_pages() end, desc = 'Find man pages' },
        { '<leader>hp', function() require('fzf-lua').packadd() end, desc = 'Find packages' },

        -- LSP Features (prefix: <leader>l)
        { '<leader>ls', function() require('fzf-lua').lsp_document_symbols() end, desc = 'Document symbols' },
        { '<leader>lw', function() require('fzf-lua').lsp_workspace_symbols() end, desc = 'Workspace symbols' },
        { '<leader>lr', function() require('fzf-lua').lsp_references() end, desc = 'Find references' },
        { '<leader>ld', function() require('fzf-lua').lsp_definitions() end, desc = 'Find definitions' },
        { '<leader>li', function() require('fzf-lua').lsp_implementations() end, desc = 'Find implementations' },
        { '<leader>lI', function() require('fzf-lua').lsp_incoming_calls() end, desc = 'Incoming calls' },
        -- stylua: ignore end
    },
}
