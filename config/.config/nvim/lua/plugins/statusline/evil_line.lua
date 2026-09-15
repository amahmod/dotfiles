local lualine = require 'lualine'

local colors = {
    bg = '#202328',
    fg = '#bbc2cf',
    yellow = '#ECBE7B',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#98be65',
    orange = '#FF8800',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand '%:p:h'
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local function get_lsp_clients()
    if vim.lsp.get_clients then
        return vim.lsp.get_clients()
    else
        return vim.lsp.buf_get_clients()
    end
end

local config = {
    options = {
        component_separators = '',
        section_separators = '',
        theme = 'auto',
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

local function insert_left(component)
    table.insert(config.sections.lualine_c, component)
end

local function insert_right(component)
    table.insert(config.sections.lualine_x, component)
end

insert_left {
    'branch',
    icon = ' ',
    color = { fg = colors.violet, gui = 'bold' },
}

insert_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
}

insert_left {
    'diff',
    symbols = {
        added = ' ',
        modified = ' ',
        removed = ' ',
    },
    cond = conditions.hide_in_width,
}

insert_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
}

insert_left {
    function()
        return '%='
    end,
    separator = '',
}

insert_left {
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.bo[0].filetype
        local clients = get_lsp_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' ',
    color = { fg = '#ffffff', gui = 'bold' },
}

insert_right { 'location' }

insert_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

insert_right {
    'filesize',
    cond = conditions.buffer_not_empty,
}

insert_right {
    function()
        return '▊'
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
}

lualine.setup(config)
