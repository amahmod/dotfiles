#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="$HOME/.config/current_wallpaper"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

launch_daemon() {
    local daemon="$1"

    if command -v setsid &>/dev/null; then
        setsid -f "$daemon" >/dev/null 2>&1
    else
        nohup "$daemon" >/dev/null 2>&1 &
    fi
}

start_daemon() {
    if command -v awww &>/dev/null; then
        if ! awww query &>/dev/null; then
            launch_daemon awww-daemon
            for _ in {1..20}; do
                if awww query &>/dev/null; then break; fi
                sleep 0.1
            done
        fi
    elif command -v swww &>/dev/null; then
        if ! swww query &>/dev/null; then
            launch_daemon swww-daemon
            for _ in {1..20}; do
                if swww query &>/dev/null; then break; fi
                sleep 0.1
            done
        fi
    fi
}

apply_wallpaper() {
    local target="$1"
    start_daemon
    if command -v awww &>/dev/null; then
        awww img "$target" --transition-type fade --transition-duration 0.5
    elif command -v swww &>/dev/null; then
        swww img "$target" --transition-type fade --transition-duration 0.5
    else
        notify-send -u critical "Wallpaper" "Neither awww nor swww is installed. Run install.sh to install awww."
        return 1
    fi
}

# 1. Restore mode (called by Hyprland autostart)
if [[ "${1:-}" == "--restore" || "${1:-}" == "restore" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        SAVED_PATH="$(cat "$STATE_FILE")"
        if [[ -f "$SAVED_PATH" ]]; then
            apply_wallpaper "$SAVED_PATH"
        fi
    fi
    exit 0
fi

# 2. Interactive / Yazi selection mode
IMAGE="${1:-}"

# Clean up any surrounding quotes or escaped quotes
IMAGE="${IMAGE#\"}"
IMAGE="${IMAGE%\"}"
IMAGE="${IMAGE#\'}"
IMAGE="${IMAGE%\'}"
IMAGE="${IMAGE#\\\"}"
IMAGE="${IMAGE%\\\"}"
IMAGE="${IMAGE#\\\'}"
IMAGE="${IMAGE%\\\'}"

if [[ -z "$IMAGE" ]]; then
    notify-send -u critical "Wallpaper" "No image selected"
    exit 1
fi

if [[ ! -f "$IMAGE" ]]; then
    notify-send -u critical "Wallpaper" "File not found: $IMAGE"
    exit 1
fi

# Validate file format via MIME type or extension
MIME=$(file -b --mime-type "$IMAGE" 2>/dev/null || true)

IS_IMAGE=0
if [[ "$MIME" == image/* ]]; then
    IS_IMAGE=1
else
    case "${IMAGE,,}" in
        *.jpg|*.jpeg|*.png|*.webp|*.gif|*.bmp|*.pnm|*.tga|*.tiff|*.avif|*.jxl)
            IS_IMAGE=1
            ;;
    esac
fi

if [[ "$IS_IMAGE" -eq 0 ]]; then
    notify-send -u critical "Wallpaper" "Selected file is not a supported image: $(basename "$IMAGE")"
    exit 1
fi

mkdir -p "$WALLPAPER_DIR"

# Extract extension and save copy to persistent directory
EXT="${IMAGE##*.}"
PERSISTENT_WALLPAPER="$WALLPAPER_DIR/current-wallpaper.${EXT}"

cp -- "$IMAGE" "$PERSISTENT_WALLPAPER"
echo "$PERSISTENT_WALLPAPER" > "$STATE_FILE"

if apply_wallpaper "$PERSISTENT_WALLPAPER"; then
    notify-send -i "$PERSISTENT_WALLPAPER" "Wallpaper Updated" "$(basename "$IMAGE")"
fi
