#!/usr/bin/env bash

if command -v wlogout &>/dev/null; then
    wlogout
else
    MENU=$(echo -e "󰌾 Lock\n󰤄 Suspend\n󰜉 Reboot\n󰐥 Shutdown\n󰈆 Exit Hyprland" | wofi --dmenu --prompt "Power Menu" --width 240 --height 210)
    case "$MENU" in
        *"Lock"*) loginctl lock-session ;;
        *"Suspend"*) systemctl suspend ;;
        *"Reboot"*) systemctl reboot ;;
        *"Shutdown"*) systemctl poweroff ;;
        *"Exit"*) hyprctl dispatch exit ;;
    esac
fi
