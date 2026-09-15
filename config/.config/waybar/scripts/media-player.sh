#!/usr/bin/env bash

# Dynamic Media Player & Controls Script for Waybar
STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" != "Playing" ] && [ "$STATUS" != "Paused" ]; then
    # Inactive -> Exit silently so Waybar hides the module
    exit 0
fi

MODE="${1:-main}"

case "$MODE" in
    "prev")
        echo '{"text": "󰒮", "tooltip": "Previous Track"}'
        ;;
    "next")
        echo '{"text": "󰒭", "tooltip": "Next Track"}'
        ;;
    "main"|*)
        ICON="󰎈"
        [ "$STATUS" = "Paused" ] && ICON="󰏤"

        ARTIST=$(playerctl metadata artist 2>/dev/null)
        TITLE=$(playerctl metadata title 2>/dev/null)

        if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
            TEXT="$ICON  $ARTIST — $TITLE"
        elif [ -n "$TITLE" ]; then
            TEXT="$ICON  $TITLE"
        else
            TEXT="$ICON  Media Playing"
        fi

        TEXT_CLEAN=$(echo "$TEXT" | tr -d '\n\r' | sed 's/"/\\"/g')
        ARTIST_CLEAN=$(echo "$ARTIST" | tr -d '\n\r' | sed 's/"/\\"/g')
        TITLE_CLEAN=$(echo "$TITLE" | tr -d '\n\r' | sed 's/"/\\"/g')

        echo "{\"text\": \"$TEXT_CLEAN\", \"class\": \"$STATUS\", \"tooltip\": \"Status: $STATUS\\nArtist: $ARTIST_CLEAN\\nTitle: $TITLE_CLEAN\"}"
        ;;
esac
