local wezterm = require('wezterm')
local keybindings = require('keybindings')

return {
  -- Font {{{
  font = wezterm.font_with_fallback({
    'MonoLisa',
    'Symbola',
  }),
  font_size = 12,
  line_height = 1.0,
  text_background_opacity = 1,
  bold_brightens_ansi_colors = true,
  bidi_enabled = true,
  -- }}}

  -- Color {{{
  color_scheme = 'Catppuccin Macchiato',
  -- }}}

  -- Window {{{
  window_padding = {
    left = 10,
    right = 10,
    top = 0,
    bottom = 0,
  },
  window_background_opacity = 0.8,
  adjust_window_size_when_changing_font_size = false,
  -- }}}

  -- Tab bar  {{{
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  -- }}}

  -- Misc {{{
  term = 'wezterm',
  selection_word_boundary = ' \t\n{}[]()"\'`.,;:!?',
  quick_select_alphabet = 'asdfqweryxcvjkluiopmghtzbn',
  quote_dropped_files = 'Posix',
  exit_behavior = 'Close',
  enable_scroll_bar = true,
  scrollback_lines = 10000,
  warn_about_missing_glyphs = false,

  disable_default_key_bindings = true,
  keys = keybindings,
  hyperlink_rules = {
    {
      regex = [[\b\w+://[\w.-]+\S*\b]],
      format = '$0',
    },
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = 'https://www.github.com/$1/$3',
    },
  },
  --}}}
}

-- vim:fdl=0:fdm=marker:
