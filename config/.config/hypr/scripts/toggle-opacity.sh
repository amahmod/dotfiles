#!/usr/bin/env bash

# Toggle Terminal Window Opacity (Solid 1.0 <-> Translucent 0.85)
OPACITY_FILE="$HOME/.config/wezterm/opacity.lua"
CURRENT=$(cat "$OPACITY_FILE" 2>/dev/null | grep -oE "[0-9.]+" || echo "1.0")

if [ "$CURRENT" = "1.0" ] || [ "$CURRENT" = "1" ]; then
    NEW_OPACITY="0.85"
    LABEL="Translucent (85%)"
else
    NEW_OPACITY="1.0"
    LABEL="Solid (100%)"
fi

mkdir -p "$HOME/.config/wezterm"
echo "return { opacity = $NEW_OPACITY }" > "$OPACITY_FILE"

if command -v notify-send &>/dev/null; then
    notify-send "Terminal Opacity" "Switched opacity to <b>$LABEL</b>" -i preferences-desktop-display
fi
