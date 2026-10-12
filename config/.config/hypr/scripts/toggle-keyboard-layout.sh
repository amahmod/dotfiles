#!/usr/bin/env bash
# ==============================================================================
# toggle-keyboard-layout.sh
# Toggle between English (US), Bengali (Avro Phonetic), and Arabic (101)
# Synchronizes Hyprland XKB layouts with IBus IME engines.
# ==============================================================================

set -eo pipefail

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/keyboard_layout_state"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
        hyprctl switchxkblayout all "$layout_id" >/dev/null 2>&1 || true
    fi
}

# Ensure IBus daemon is running if ibus is installed
if ! pgrep -x ibus-daemon >/dev/null; then
    if [[ -x "$SCRIPT_DIR/launch-ibus.sh" ]]; then
        bash "$SCRIPT_DIR/launch-ibus.sh"
    elif command -v ibus-daemon >/dev/null; then
        nohup /usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im --exec-daemon --daemon-args "-d -r -x --panel disable" >/dev/null 2>&1 &
    fi
    sleep 0.3
fi

# Detect current state
current_state=""
if [[ -f "$STATE_FILE" ]]; then
    current_state=$(cat "$STATE_FILE" 2>/dev/null | tr -d '[:space:]')
fi

if [[ -z "$current_state" ]]; then
    # Fallback detection via ibus engine
    if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
        engine=$(ibus engine 2>/dev/null || echo "")
        if [[ "$engine" == *"avro"* ]]; then
            current_state="avro"
        elif [[ "$engine" == *"ara"* ]]; then
            current_state="ara"
        else
            current_state="us"
        fi
    else
        current_state="us"
    fi
fi

# Determine target
case "${1:-}" in
    "us"|"en"|"english")
        target="us"
        ;;
    "avro"|"bn"|"bangla"|"bengali")
        target="avro"
        ;;
    "ara"|"ar"|"arabic")
        target="ara"
        ;;
    *)
        # Cycle: English (us) -> Bengali (avro) -> Arabic (ara) -> English (us)
        if [[ "$current_state" == "us" ]]; then
            target="avro"
        elif [[ "$current_state" == "avro" ]]; then
            target="ara"
        elif [[ "$current_state" == "ara" ]]; then
            target="us"
        else
            target="avro"
        fi
        ;;
esac

# Execute switch
case "$target" in
    "avro")
        set_hyprland_layout 0
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine ibus-avro 2>/dev/null || true
        fi
        echo "avro" > "$STATE_FILE"
        send_notification "Keyboard Layout" "বাংলা (Avro Phonetic)"
        ;;
    "ara")
        set_hyprland_layout 1
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine xkb:ara::ara 2>/dev/null || true
        fi
        echo "ara" > "$STATE_FILE"
        send_notification "Keyboard Layout" "العربية (Arabic 101)"
        ;;
    "us"|*)
        set_hyprland_layout 0
        if command -v ibus >/dev/null && pgrep -x ibus-daemon >/dev/null; then
            ibus engine xkb:us::eng 2>/dev/null || true
        fi
        echo "us" > "$STATE_FILE"
        send_notification "Keyboard Layout" "English (US)"
        ;;
esac
