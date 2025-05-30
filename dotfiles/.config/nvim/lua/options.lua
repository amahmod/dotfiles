local opt = vim.opt

-- ───────────────────────────────( Files )────────────────────────────────
opt.swapfile = false
opt.undofile = true -- Persistent undo
opt.undolevels = 10000
opt.writebackup = false -- Don't make a backup before overwriting a file

-- ───────────────────────────────( Search )────────────────────────────────
opt.ignorecase = true -- Search ignoring case
opt.smartcase = true -- Keep case when searching with *
opt.incsearch = true -- Incremental search
opt.inccommand = 'split'
opt.grepformat = '%f:%l:%c:%m'

-- ───────────────────────────────( Indentation )────────────────────────────
opt.expandtab = true -- Expand tabs to spaces
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.smartindent = true -- Smart indent
opt.tabstop = 4 -- Number of spaces tabs count for

-- ───────────────────────────────( Window Management )────────────────────────────
opt.splitbelow = true -- Splits open bottom right
opt.splitright = true
opt.equalalways = true -- Resize windows on split or close

-- ───────────────────────────────( UI Elements )────────────────────────────
opt.number = true -- Show line number
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = 'yes' -- Always show the signcolumn
opt.list = true -- Show hidden characters
opt.wrap = false -- No wrap by default
opt.winbar = '%m %f'
opt.sidescrolloff = 5 -- Keep at least 5 lines left/right
opt.cursorline = true -- Highlight current line
opt.laststatus = 3 -- Global statusline

-- ───────────────────────────────( Editor Behavior )────────────────────────────
opt.spell = true
opt.formatoptions:remove 'o' -- Don't add comment leader on 'o'

-- ───────────────────────────────( Folding )────────────────────────────

-- Enhanced fold text function with syntax highlighting and visual indicators
function custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local fold_level = vim.fn.foldlevel(vim.v.foldstart)
    local indent = string.rep('  ', fold_level - 1)

    -- Get the first non-empty line in the fold
    local first_line = line:match '^%s*(.-)%s*$'
    if first_line == '' then
        for i = vim.v.foldstart + 1, vim.v.foldend do
            first_line = vim.fn.getline(i):match '^%s*(.-)%s*$'
            if first_line ~= '' then
                break
            end
        end
    end

    -- Truncate if too long
    if #first_line > 50 then
        first_line = first_line:sub(1, 47) .. '...'
    end

    -- Create a more visually appealing fold text
    local lines_text = line_count == 1 and '1 line' or line_count .. ' lines'
    local fold_icon = '▸' -- Triangle icon for closed folds
    local fold_separator = '─' -- Separator line
    local padding = string.rep(' ', 3 - #tostring(line_count))

    -- Format the fold text with visual elements
    local fold_text = string.format(
        '%s%s %s %s%s %s',
        indent,
        fold_icon,
        first_line,
        fold_separator,
        padding,
        lines_text
    )

    -- Return a table with the fold text and highlight groups
    return {
        { fold_text, 'Folded' },
    }
end

-- Configure folding
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext = 'v:lua.custom_fold_text()'

-- ───────────────────────────────( Filetype Detection )────────────────────────────
vim.filetype.add {
    filename = {
        ['yarn.lock'] = 'yaml',
        ['.jsbeautifyrc'] = 'json',
        ['.jscsrc'] = 'json',
    },
    extension = {
        pcss = 'css',
    },
    pattern = {
        ['.*%.js%.map'] = 'json',
        ['.*%.postman_collection'] = 'json',
        ['Jenkinsfile.*'] = 'groovy',
    },
}
