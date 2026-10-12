#!/usr/bin/env bash
# ==============================================================================
# launch-ibus.sh
# Autostart IBus on Hyprland (Wayland) using official Wayland input-method protocol
# ==============================================================================

if pgrep -x ibus-daemon >/dev/null; then
    exit 0
fi

# Execute via ibus-ui-gtk3 as parent with Wayland IM protocol connected
nohup /usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im --exec-daemon --daemon-args "-d -r -x --panel disable" >/dev/null 2>&1 &
