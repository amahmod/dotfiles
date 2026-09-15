local wezterm = require 'wezterm'
local act = wezterm.action

return {
  -- {{{ COPY/PASTE (Enter for copy mode, c/v for copy/paste)
  { key = 'Enter', mods = 'ALT', action = 'ActivateCopyMode' },
  { key = 'c', mods = 'ALT', action = act { CopyTo = 'Clipboard' } },
  { key = 'v', mods = 'ALT', action = act { PasteFrom = 'Clipboard' } },
  -- }}}

  -- {{{ SCROLL (u/d for half page, ctrl+u/d pattern)
  { key = 'u', mods = 'ALT', action = wezterm.action.ScrollByPage(-0.5) },
  { key = 'd', mods = 'ALT', action = wezterm.action.ScrollByPage(0.5) },
  { key = 'g', mods = 'ALT', action = 'ScrollToTop' },
  { key = 'G', mods = 'ALT|SHIFT', action = 'ScrollToBottom' },
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
  {
    key = 's',
    mods = 'ALT|SHIFT',
    action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } },
  },
  {
    key = 'v',
    mods = 'ALT|SHIFT',
    action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } },
  },
  -- }}}

  -- {{{ PANE NAVIGATION (vim-like hjkl)
  { key = 'h', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Left' } },
  { key = 'j', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Down' } },
  { key = 'k', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Up' } },
  { key = 'l', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Right' } },
  -- }}}

  -- {{{ PANE RESIZE (SHIFT+hjkl for resize)
  { key = 'H', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
  { key = 'J', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
  { key = 'K', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
  { key = 'L', mods = 'ALT|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
  -- }}}

  -- {{{ CLOSE (q for quit pane, Q for quit tab)
  { key = 'q', mods = 'ALT', action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'Q', mods = 'ALT|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  -- }}}

  -- {{{ TABS (t for tab, n/p for next/prev, numbers for direct)
  { key = 'n', mods = 'ALT', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
  { key = '.', mods = 'ALT', action = wezterm.action { ActivateTabRelativeNoWrap = 1 } },
  { key = ',', mods = 'ALT', action = wezterm.action { ActivateTabRelativeNoWrap = -1 } },
  { key = '1', mods = 'ALT', action = wezterm.action { ActivateTab = 0 } },
  { key = '2', mods = 'ALT', action = wezterm.action { ActivateTab = 1 } },
  { key = '3', mods = 'ALT', action = wezterm.action { ActivateTab = 2 } },
  { key = '4', mods = 'ALT', action = wezterm.action { ActivateTab = 3 } },
  { key = '5', mods = 'ALT', action = wezterm.action { ActivateTab = 4 } },
  { key = '6', mods = 'ALT', action = wezterm.action { ActivateTab = 5 } },
  { key = '7', mods = 'ALT', action = wezterm.action { ActivateTab = 6 } },
  { key = '8', mods = 'ALT', action = wezterm.action { ActivateTab = 7 } },
  { key = '9', mods = 'ALT', action = wezterm.action { ActivateTab = 8 } },
  -- }}}

  -- {{{ FONT SIZE (+/- for bigger/smaller, 0 for reset)
  { key = '=', mods = 'ALT', action = 'IncreaseFontSize' },
  { key = '+', mods = 'ALT', action = 'IncreaseFontSize' },
  { key = '-', mods = 'ALT', action = 'DecreaseFontSize' },
  { key = '0', mods = 'ALT', action = 'ResetFontSize' },
  { key = 'Numpad0', mods = 'ALT', action = 'ResetFontSize' },
  -- }}}

  -- {{{ SEARCH & MISC (/ for search, o for open urls, space for launcher)
  {
    key = '/',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      local selection = window:get_selection_text_for_pane(pane)
      window:perform_action(wezterm.action { Search = { CaseInSensitiveString = selection } }, pane)
    end),
  },
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
  { key = 'Space', mods = 'ALT', action = wezterm.action.ShowLauncher },
  -- }}}
}

-- vim:fdl=0:fdm=marker:
