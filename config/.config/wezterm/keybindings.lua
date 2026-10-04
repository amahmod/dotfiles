local wezterm = require 'wezterm'
local act = wezterm.action

--- Walk sibling panes along the specified axis ('x' or 'y')
local function walk_siblings(axis, tab, window, pane, do_func)
    local initial_pane = pane
    local siblings = { (do_func and do_func(initial_pane) or initial_pane) }
    local prev_dir = axis == 'x' and 'Left' or 'Up'
    local next_dir = axis == 'x' and 'Right' or 'Down'
    local max_iter = 20

    local initial_pane_idx = 1
    local panes_info = tab:panes_with_info()
    for _, pi in ipairs(panes_info) do
        if pi.is_active then
            initial_pane_idx = pi.index
        end
    end

    for _, step_dir in ipairs { 'prev', 'next' } do
        local last_pane = tab:active_pane()
        window:perform_action(
            wezterm.action.ActivatePaneDirection(step_dir == 'prev' and prev_dir or next_dir),
            tab:active_pane()
        )
        local new_pane = tab:active_pane()
        local i = 0
        while new_pane:pane_id() ~= last_pane:pane_id() and i < max_iter do
            if step_dir == 'prev' then
                table.insert(siblings, 1, (do_func and do_func(new_pane) or new_pane))
            else
                table.insert(siblings, (do_func and do_func(new_pane) or new_pane))
            end
            last_pane = tab:active_pane()
            window:perform_action(
                wezterm.action.ActivatePaneDirection(step_dir == 'prev' and prev_dir or next_dir),
                tab:active_pane()
            )
            new_pane = tab:active_pane()
            i = i + 1
        end
        window:perform_action(wezterm.action.ActivatePaneByIndex(initial_pane_idx), tab:active_pane())
    end
    return siblings
end

--- Balance panes along an axis ('x' for width, 'y' for height)
local function balance_panes(axis)
    return function(window, pane)
        local tab = window:active_tab()
        local prev_dir = axis == 'x' and 'Left' or 'Up'
        local next_dir = axis == 'x' and 'Right' or 'Down'
        local siblings = walk_siblings(axis, tab, window, pane)
        if #siblings <= 1 then
            return
        end
        local tab_size = tab:get_size()[axis == 'x' and 'cols' or 'rows']
        local balanced_size = math.floor(tab_size / #siblings)
        local pane_size_key = axis == 'x' and 'cols' or 'viewport_rows'

        walk_siblings(axis, tab, window, pane, function(p)
            local pane_size = p:get_dimensions()[pane_size_key]
            local adj_amount = pane_size - balanced_size
            local adj_dir = adj_amount < 0 and next_dir or prev_dir
            adj_amount = math.abs(adj_amount)
            if adj_amount > 0 then
                window:perform_action(wezterm.action.AdjustPaneSize { adj_dir, adj_amount }, p)
            end
        end)
    end
end

--- Reset and equalize all pane sizes on the active tab
local function reset_pane_sizes(window, pane)
    local tab = window:active_tab()
    local panes_info = tab:panes_with_info()
    for _, pi in ipairs(panes_info) do
        if pi.is_zoomed then
            window:perform_action(wezterm.action.TogglePaneZoomState, pane)
            return
        end
    end
    balance_panes 'x'(window, pane)
    balance_panes 'y'(window, pane)
end

return {
    -- {{{ COPY/PASTE (Enter for copy mode, c/v for copy/paste)
    -- Activate terminal copy mode
    { key = 'Enter', mods = 'ALT', action = 'ActivateCopyMode' },
    -- Copy selection to clipboard
    { key = 'c', mods = 'ALT', action = act { CopyTo = 'Clipboard' } },
    -- Paste from clipboard
    { key = 'v', mods = 'ALT', action = act { PasteFrom = 'Clipboard' } },
    -- }}}

    -- {{{ SCROLL (u/d for half page, ctrl+u/d pattern)
    -- Scroll half page up
    { key = 'u', mods = 'ALT', action = wezterm.action.ScrollByPage(-0.5) },
    -- Scroll half page down
    { key = 'd', mods = 'ALT', action = wezterm.action.ScrollByPage(0.5) },
    -- Scroll to top of scrollback
    { key = 'g', mods = 'ALT', action = 'ScrollToTop' },
    -- Scroll to bottom of scrollback
    { key = 'G', mods = 'ALT|SHIFT', action = 'ScrollToBottom' },
    -- Scroll to top (in alternate screen: send Home key)
    {
        key = 'Home',
        mods = '',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(wezterm.action { SendKey = { key = 'Home', mods = '' } }, pane)
            else
                window:perform_action('ScrollToTop', pane)
            end
        end),
    },
    -- Scroll to bottom (in alternate screen: send End key)
    {
        key = 'End',
        mods = '',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(wezterm.action { SendKey = { key = 'End', mods = '' } }, pane)
            else
                window:perform_action('ScrollToBottom', pane)
            end
        end),
    },
    -- Scroll page up (in alternate screen: send PageUp key)
    {
        key = 'PageUp',
        mods = '',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(wezterm.action { SendKey = { key = 'PageUp', mods = '' } }, pane)
            else
                window:perform_action(wezterm.action { ScrollByPage = -1 }, pane)
            end
        end),
    },
    -- Scroll page down (in alternate screen: send PageDown key)
    {
        key = 'PageDown',
        mods = '',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(wezterm.action { SendKey = { key = 'PageDown', mods = '' } }, pane)
            else
                window:perform_action(wezterm.action { ScrollByPage = 1 }, pane)
            end
        end),
    },
    -- }}}

    -- {{{ SPLIT PANES (s for split, intuitive directions)
    -- Split pane vertically
    {
        key = 's',
        mods = 'ALT|SHIFT',
        action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } },
    },
    -- Split pane horizontally
    {
        key = 'v',
        mods = 'ALT|SHIFT',
        action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } },
    },
    -- }}}

    -- {{{ PANE NAVIGATION (vim-like hjkl)
    -- Focus pane to the left
    { key = 'h', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Left' } },
    -- Focus pane below
    { key = 'j', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Down' } },
    -- Focus pane above
    { key = 'k', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Up' } },
    -- Focus pane to the right
    { key = 'l', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Right' } },
    -- }}}

    -- {{{ PANE RESIZE (SHIFT+hjkl for resize, R for reset)
    -- Resize pane left
    { key = 'H', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
    -- Resize pane down
    { key = 'J', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
    -- Resize pane up
    { key = 'K', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
    -- Resize pane right
    { key = 'L', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
    -- Reset and balance all pane sizes
    { key = 'R', mods = 'ALT|SHIFT', action = wezterm.action_callback(reset_pane_sizes) },
    -- Toggle pane zoom (maximize/restore active pane)
    { key = 'z', mods = 'ALT', action = wezterm.action.TogglePaneZoomState },
    -- }}}

    -- {{{ CLOSE (q for quit pane, Q for quit tab)
    -- Close active pane
    { key = 'q', mods = 'ALT', action = wezterm.action.CloseCurrentPane { confirm = false } },
    -- Close active tab
    { key = 'Q', mods = 'ALT|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
    -- }}}

    -- {{{ TABS (t for tab, n/p for next/prev, numbers for direct)
    -- Create new tab
    { key = 'n', mods = 'ALT', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
    -- Switch to next tab
    { key = '.', mods = 'ALT', action = wezterm.action { ActivateTabRelativeNoWrap = 1 } },
    -- Switch to previous tab
    { key = ',', mods = 'ALT', action = wezterm.action { ActivateTabRelativeNoWrap = -1 } },
    -- Switch to tab 1
    { key = '1', mods = 'ALT', action = wezterm.action { ActivateTab = 0 } },
    -- Switch to tab 2
    { key = '2', mods = 'ALT', action = wezterm.action { ActivateTab = 1 } },
    -- Switch to tab 3
    { key = '3', mods = 'ALT', action = wezterm.action { ActivateTab = 2 } },
    -- Switch to tab 4
    { key = '4', mods = 'ALT', action = wezterm.action { ActivateTab = 3 } },
    -- Switch to tab 5
    { key = '5', mods = 'ALT', action = wezterm.action { ActivateTab = 4 } },
    -- Switch to tab 6
    { key = '6', mods = 'ALT', action = wezterm.action { ActivateTab = 5 } },
    -- Switch to tab 7
    { key = '7', mods = 'ALT', action = wezterm.action { ActivateTab = 6 } },
    -- Switch to tab 8
    { key = '8', mods = 'ALT', action = wezterm.action { ActivateTab = 7 } },
    -- Switch to tab 9
    { key = '9', mods = 'ALT', action = wezterm.action { ActivateTab = 8 } },
    -- }}}

    -- {{{ FONT SIZE (+/- for bigger/smaller, 0 for reset)
    -- Increase font size
    { key = '=', mods = 'ALT', action = 'IncreaseFontSize' },
    -- Increase font size
    { key = '+', mods = 'ALT', action = 'IncreaseFontSize' },
    -- Decrease font size
    { key = '-', mods = 'ALT', action = 'DecreaseFontSize' },
    -- Reset font size to default
    { key = '0', mods = 'ALT', action = 'ResetFontSize' },
    -- Reset font size to default
    { key = 'Numpad0', mods = 'ALT', action = 'ResetFontSize' },
    -- }}}

    -- {{{ SEARCH & MISC (/ for search, o for open urls, space for launcher)
    -- Search selected text
    {
        key = '/',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            local selection = window:get_selection_text_for_pane(pane)
            window:perform_action(wezterm.action { Search = { CaseInSensitiveString = selection } }, pane)
        end),
    },
    -- QuickSelect and open URL in browser
    {
        key = 'o',
        mods = 'ALT',
        action = wezterm.action {
            QuickSelectArgs = {
                label = 'open url',
                patterns = {
                    'https?://\\S+',
                },
                action = wezterm.action_callback(function(window, pane)
                    local url = window:get_selection_text_for_pane(pane)
                    wezterm.log_info('opening: ' .. url)
                    wezterm.open_with(url)
                end),
            },
        },
    },
    -- Show WezTerm launcher menu
    { key = 'Space', mods = 'ALT', action = wezterm.action.ShowLauncher },
    -- }}}
}

-- vim:fdl=0:fdm=marker:
