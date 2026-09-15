local opt = vim.opt

-- Files
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.writebackup = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.inccommand = 'split'
opt.grepformat = '%f:%l:%c:%m'

-- Indentation
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4

-- Window Management
opt.splitbelow = true
opt.splitright = true
opt.equalalways = true

-- UI Elements
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.list = true
opt.wrap = false
opt.winbar = '%m %f'
opt.sidescrolloff = 5
opt.cursorline = true
opt.laststatus = 3

-- Editor Behavior
opt.spell = true
opt.formatoptions:remove 'o'

-- Enhanced fold text function
function custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local fold_level = vim.fn.foldlevel(vim.v.foldstart)
    local indent = string.rep('  ', fold_level - 1)

    local first_line = line:match '^%s*(.-)%s*$'
    if first_line == '' then
        for i = vim.v.foldstart + 1, vim.v.foldend do
            first_line = vim.fn.getline(i):match '^%s*(.-)%s*$'
            if first_line ~= '' then
                break
            end
        end
    end

    if #first_line > 50 then
        first_line = first_line:sub(1, 47) .. '...'
    end

    local lines_text = line_count == 1 and '1 line' or line_count .. ' lines'
    local fold_icon = '▸'
    local fold_separator = '─'
    local padding = string.rep(' ', 3 - #tostring(line_count))

    local fold_text = string.format(
        '%s%s %s %s%s %s',
        indent,
        fold_icon,
        first_line,
        fold_separator,
        padding,
        lines_text
    )

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

-- Filetype Detection
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
