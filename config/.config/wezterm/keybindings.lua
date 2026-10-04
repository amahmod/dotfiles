local wezterm = require 'wezterm'
local act = wezterm.action

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

    -- {{{ PANE RESIZE (SHIFT+hjkl for resize)
    -- Resize pane left
    { key = 'H', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
    -- Resize pane down
    { key = 'J', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
    -- Resize pane up
    { key = 'K', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
    -- Resize pane right
    { key = 'L', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
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
