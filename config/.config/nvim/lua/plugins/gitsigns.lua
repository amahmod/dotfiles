return {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        current_line_blame = false,
        attach_to_untracked = true,
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },
        preview_config = {
            border = 'rounded',
        },
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            map("n", "]c", gs.next_hunk, "Next Hunk")
            map("n", "[c", gs.prev_hunk, "Prev Hunk")

            map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

            map("n", "<leader>bs", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>br", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")

            map("n", "<leader>bL", function() gs.blame_line { full = true } end, "Blame Line")
            map("n", "<leader>bl", gs.toggle_current_line_blame, "Toggle Line Blame")

            map("n", "<leader>db", gs.diffthis, "Diff This")
            map("n", "<leader>dB", function() gs.diffthis "~" end, "Diff This ~")

            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
        end,
    },
}
