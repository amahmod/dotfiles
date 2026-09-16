#!/usr/bin/env bash

set -euo pipefail

OVERRIDE="$HOME/.config/waybar/bg-override.css"
STATE="$HOME/.config/waybar/.bg-hidden"

if [[ -f "$STATE" ]]; then
    printf '/* Waybar module backgrounds are enabled by default. */\n' > "$OVERRIDE"
    rm -f "$STATE"
    MESSAGE="Waybar backgrounds enabled"
else
    cat > "$OVERRIDE" <<'EOF'
window#waybar .module,
window#waybar .module:hover,
window#waybar .module:active,
window#waybar .module:checked,
window#waybar .module:selected,
window#waybar .module *,
window#waybar .module *:hover,
window#waybar .module *:active,
window#waybar .module *:checked,
window#waybar .module *:selected {
    background-color: transparent;
    background: transparent;
}
EOF
    touch "$STATE"
    MESSAGE="Waybar backgrounds disabled"
fi

pkill -x -USR2 waybar 2>/dev/null || true

if command -v notify-send &>/dev/null; then
    notify-send "Waybar" "$MESSAGE"
fi
