#!/usr/bin/env bash

# Screenshot Handler for Hyprland
# - SUPER + S: Active window capture (auto-saved + auto-copied)
# - SUPER + SHIFT + S: Area selection with Satty / Swappy annotation GUI
#   (Does not auto-save or auto-copy until user saves or copies in the interactive tool)

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +'%Y%m%d-%H%M%S')
FILE_PATH="$SCREENSHOT_DIR/screenshot-${TIMESTAMP}.png"

MODE="$1" # "area", "window", or "full"

if [ "$MODE" = "window" ]; then
    GEOM=$(hyprctl activewindow -j 2>/dev/null | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null)
    if [ -n "$GEOM" ] && [ "$GEOM" != "null,null 0x0" ]; then
        grim -g "$GEOM" "$FILE_PATH"
    else
        grim "$FILE_PATH"
    fi
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Active window saved to ~/Pictures/Screenshots/\nCopied to clipboard" -i camera-photo
    exit 0
fi

if [ "$MODE" = "full" ]; then
    grim "$FILE_PATH"
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Full screen saved to ~/Pictures/Screenshots/\nCopied to clipboard" -i camera-photo
    exit 0
fi

# Area selection mode (Interactive GUI)
GEOM=$(slurp 2>/dev/null)
if [ -z "$GEOM" ]; then
    exit 0 # User cancelled selection
fi

# Pipe raw selection directly into interactive annotation tool without pre-saving or pre-copying
if command -v satty &>/dev/null; then
    grim -g "$GEOM" - | satty --filename - --output-filename "$FILE_PATH" --copy-command "wl-copy" --early-exit
elif command -v swappy &>/dev/null; then
    grim -g "$GEOM" - | swappy -f - -o "$FILE_PATH"
else
    # Fallback if no annotation tool is installed
    grim -g "$GEOM" "$FILE_PATH"
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Saved to ~/Pictures/Screenshots/\nCopied to clipboard.\nInstall <b>satty</b> for interactive annotations." -i camera-photo
fi
