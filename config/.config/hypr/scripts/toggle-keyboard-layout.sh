#!/usr/bin/env bash
# ==============================================================================
# toggle-keyboard-layout.sh
# Toggle between English (US), Bengali (Avro Phonetic), and Arabic (101)
# Supports IBus IME engine switching with synchronized Hyprland XKB layouts.
# ==============================================================================

set -eo pipefail

send_notification() {
    local title="$1"
    local message="$2"
    local icon="${3:-input-keyboard}"

    if command -v dunstify &>/dev/null; then
        dunstify -a "keyboard-layout" -r 2580 -u low -i "$icon" "$title" "$message" -t 1500
    elif command -v notify-send &>/dev/null; then
        notify-send -a "keyboard-layout" -h string:x-canonical-private-synchronous:keyboard-layout -u low -i "$icon" "$title" "$message" -t 1500
    fi
}

set_hyprland_layout() {
    local layout_id="$1" # 0 for us, 1 for ara
    if command -v hyprctl >/dev/null; then
        local keyboards
        keyboards=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[]?.name' 2>/dev/null || true)
        if [[ -n "$keyboards" ]]; then
            for kb in $keyboards; do
                hyprctl switchxkblayout "$kb" "$layout_id" >/dev/null 2>&1 || true
            done
        fi
    fi
}

# Ensure ibus-daemon is running if ibus is installed
if ! pgrep -x ibus-daemon >/dev/null && command -v ibus-daemon >/dev/null; then
    ibus-daemon -drx --panel=/usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im 2>/dev/null || true
    sleep 0.5
fi

# Detect current state
current_engine=""
if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
    current_engine=$(ibus engine 2>/dev/null || echo "")
fi

# Target selection
case "$1" in
    "us"|"en"|"english")
        target="xkb:us::eng"
        ;;
    "avro"|"bn"|"bangla"|"bengali")
        target="ibus-avro"
        ;;
    "ara"|"ar"|"arabic")
        target="xkb:ara::ara"
        ;;
    *)
        # Cycle: English -> Bengali (Avro Phonetic) -> Arabic (101) -> English
        if [[ "$current_engine" == "ibus-avro" || "$current_engine" == *"avro"* || "$current_engine" == *"openbangla"* ]]; then
            target="xkb:ara::ara"
        elif [[ "$current_engine" == *"ara"* ]]; then
            target="xkb:us::eng"
        else
            target="ibus-avro"
        fi
        ;;
esac

# Execute switch
case "$target" in
    "ibus-avro"|*"avro"*)
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine ibus-avro 2>/dev/null || true
        fi
        set_hyprland_layout 0
        send_notification "Keyboard Layout" "বাংলা (Avro Phonetic)"
        ;;
    *"ara"*)
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine xkb:ara::ara 2>/dev/null || true
        fi
        set_hyprland_layout 1
        send_notification "Keyboard Layout" "العربية (Arabic 101)"
        ;;
    *)
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine xkb:us::eng 2>/dev/null || true
        fi
        set_hyprland_layout 0
        send_notification "Keyboard Layout" "English (US)"
        ;;
esac
