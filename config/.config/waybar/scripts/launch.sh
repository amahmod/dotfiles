#!/usr/bin/env bash

# Directory of Waybar config
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terminate existing Waybar instances cleanly
killall -q waybar || true
while pgrep -u "$UID" -x waybar >/dev/null; do sleep 0.1; done

# Check if hyprctl is available
if ! command -v hyprctl &>/dev/null; then
    exit 0
fi

# Detect monitors using hyprctl and jq
MONITORS=($(hyprctl monitors -j 2>/dev/null | jq -r 'sort_by(.x, .id) | .[].name' 2>/dev/null))
COUNT=${#MONITORS[@]}

# Default fallback if no monitors returned
if [ "$COUNT" -eq 0 ]; then
    PRIMARY="DP-1"
    SECONDARY="HDMI-A-1"
elif [ "$COUNT" -eq 1 ]; then
    PRIMARY="${MONITORS[0]}"
    SECONDARY="HDMI-A-1"
else
    PRIMARY="${MONITORS[0]}"
    SECONDARY="${MONITORS[1]}"
fi

# Check for battery presence (laptops)
BATTERY_MODULE=""
if [ -d /sys/class/power_supply ] && [ "$(ls -A /sys/class/power_supply 2>/dev/null | wc -l)" -gt 0 ]; then
    BATTERY_MODULE=', "battery"'
fi

# Ensure default audio sink is aligned to the active output
RUNNING_SINK=$(pactl list short sinks 2>/dev/null | grep "RUNNING" | awk '{print $2}' | head -n1)
if [ -n "$RUNNING_SINK" ]; then
    pactl set-default-sink "$RUNNING_SINK" 2>/dev/null || true
fi

if [ "$COUNT" -le 1 ]; then
    # --- Single Monitor Mode ---
    # Workspaces 1-10 on primary monitor
    for w in $(seq 1 10); do
        is_default="false"
        [ "$w" -eq 1 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$PRIMARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    sed -e "s/__PRIMARY__/$PRIMARY/g" -e "s/__BATTERY__/$BATTERY_MODULE/g" << 'EOF' > "$DIR/config.jsonc"
{
  "name": "main",
  "output": ["__PRIMARY__"],
  "layer": "top",
  "position": "top",
  "height": 36,
  "margin-top": 6,
  "margin-left": 12,
  "margin-right": 12,
  "spacing": 6,
  "modules-left": ["custom/arch", "hyprland/workspaces", "hyprland/window"],
  "modules-center": ["custom/media-prev", "custom/media", "custom/media-next", "clock"],
  "modules-right": ["cpu", "memory", "network"__BATTERY__, "tray", "pulseaudio", "custom/power"],
  "custom/arch": {
    "format": "󰣇",
    "tooltip-format": "Media Control Center\n\n• Left-Click: App Launcher\n• Right-Click: Music Player",
    "on-click": "wofi --show drun",
    "on-click-right": "amberol || spotify || rhythmbox"
  },
  "hyprland/workspaces": {
    "all-outputs": false,
    "active-only": false,
    "on-click": "activate",
    "format": "{name}",
    "tooltip": true,
    "tooltip-format": "Workspace {name}\n{windows}"
  },
  "hyprland/window": {
    "format": "󰘔 {title}",
    "max-length": 32,
    "separate-outputs": true
  },
  "custom/media-prev": {
    "format": "󰒮",
    "tooltip-format": "Previous Track",
    "on-click": "playerctl previous"
  },
  "custom/media": {
    "format": "{icon} {text}",
    "return-type": "json",
    "format-icons": {
      "Playing": "󰎈",
      "Paused": "󰏤"
    },
    "escape": true,
    "exec": "playerctl metadata --format '{\"text\": \"{{artist}} — {{title}}\", \"alt\": \"{{status}}\", \"tooltip\": \"Title: {{title}}\\nArtist: {{artist}}\\nAlbum: {{album}}\\nStatus: {{status}}\"}' 2>/dev/null || echo '{\"text\": \"No Media Playing\", \"alt\": \"Paused\", \"tooltip\": \"No active media player\"}'",
    "on-click": "playerctl play-pause",
    "on-scroll-up": "playerctl next",
    "on-scroll-down": "playerctl previous",
    "max-length": 38
  },
  "custom/media-next": {
    "format": "󰒭",
    "tooltip-format": "Next Track",
    "on-click": "playerctl next"
  },
  "clock": {
    "format": "󰥔 {:%I:%M %p}",
    "format-alt": "󰃭 {:%A, %B %d, %Y  󰥔 %I:%M %p}",
    "tooltip-format": "<span size='18000' weight='bold' color='#89dceb'>  󰃭 {:%B %Y}</span>\n\n<tt><span size='15000'>{calendar}</span></tt>",
    "calendar": {
      "mode": "month",
      "mode-mon-col": 3,
      "weeks-pos": "right",
      "on-scroll": 1,
      "format": {
        "months": "<span color=\"#a6e3a1\"><b>{}</b></span>",
        "days": "<span color=\"#cdd6f4\"><b>{}</b></span>",
        "weeks": "<span color=\"#89dceb\"><b>W{}</b></span>",
        "weekdays": "<span color=\"#f9e2af\"><b>{}</b></span>",
        "today": "<span color=\"#f5c2e7\"><b><u>{}</u></b></span>"
      }
    },
    "actions": {
      "on-click-right": "mode",
      "on-scroll-up": "shift_up",
      "on-scroll-down": "shift_down"
    }
  },
  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰝟 Muted",
    "format-icons": {
      "headphone": "󰋋",
      "hands-free": "󰋎",
      "headset": "󰋎",
      "phone": "󰏲",
      "portable": "󰏲",
      "car": "󰄋",
      "default": ["󰕿", "󰖀", "󰕾"]
    },
    "scroll-step": 5,
    "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    "on-click-right": "pavucontrol",
    "on-scroll-up": "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
    "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  },
  "cpu": {
    "format": " {usage}%",
    "interval": 2,
    "tooltip": true,
    "on-click": "wezterm start btop"
  },
  "memory": {
    "format": " {used:0.1f}G",
    "tooltip-format": "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)",
    "interval": 2,
    "on-click": "wezterm start btop"
  },
  "network": {
    "interval": 2,
    "format-wifi": "󰤨 󰇚{bandwidthDownBytes}",
    "format-ethernet": "󰈀 󰇚{bandwidthDownBytes}",
    "format-disconnected": "󰤮 Offline",
    "min-length": 14,
    "on-click": "wezterm start nmtui"
  },
  "battery": {
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "{icon} {capacity}%",
    "format-charging": "󰂄 {capacity}%",
    "format-plugged": "󰚥 {capacity}%",
    "format-icons": ["󰂎", "󰁺", "󰁼", "󰁾", "󰂀", "󰁹"]
  },
  "tray": {
    "icon-size": 16,
    "spacing": 8
  },
  "custom/power": {
    "format": "󰐥",
    "tooltip-format": "Power Options",
    "on-click": "bash ~/.config/waybar/scripts/power-menu.sh"
  }
}
EOF

else
    # --- Multi-Monitor Mode (2+ Monitors) ---
    # NO DUPLICATE MODULES across monitors!
    # Primary: Workspaces 1-5
    # Secondary: Workspaces 6-10
    SECONDARY="${MONITORS[1]}"

    # Primary gets workspaces 1-5
    for w in $(seq 1 5); do
        is_default="false"
        [ "$w" -eq 1 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$PRIMARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    # Secondary gets workspaces 6-10
    for w in $(seq 6 10); do
        is_default="false"
        [ "$w" -eq 6 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$SECONDARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    sed -e "s/__PRIMARY__/$PRIMARY/g" -e "s/__SECONDARY__/$SECONDARY/g" -e "s/__BATTERY__/$BATTERY_MODULE/g" << 'EOF' > "$DIR/config.jsonc"
[
  {
    "name": "primary",
    "output": ["__PRIMARY__"],
    "layer": "top",
    "position": "top",
    "height": 36,
    "margin-top": 6,
    "margin-left": 12,
    "margin-right": 12,
    "spacing": 6,
    "modules-left": ["custom/arch", "hyprland/workspaces", "hyprland/window"],
    "modules-center": ["custom/media-prev", "custom/media", "custom/media-next", "clock"],
    "modules-right": ["cpu", "memory", "network"__BATTERY__, "tray", "pulseaudio", "custom/power"],
    "custom/arch": {
      "format": "󰣇",
      "tooltip-format": "Media Control Center\n\n• Left-Click: App Launcher\n• Right-Click: Music Player",
      "on-click": "wofi --show drun",
      "on-click-right": "amberol || spotify || rhythmbox"
    },
    "hyprland/workspaces": {
      "all-outputs": false,
      "active-only": false,
      "on-click": "activate",
      "format": "{name}",
      "tooltip": true,
      "tooltip-format": "Workspace {name}\n{windows}"
    },
    "hyprland/window": {
      "format": "󰘔 {title}",
      "max-length": 32,
      "separate-outputs": true
    },
    "custom/media-prev": {
      "format": "󰒮",
      "tooltip-format": "Previous Track",
      "on-click": "playerctl previous"
    },
    "custom/media": {
      "format": "{icon} {text}",
      "return-type": "json",
      "format-icons": {
        "Playing": "󰎈",
        "Paused": "󰏤"
      },
      "escape": true,
      "exec": "playerctl metadata --format '{\"text\": \"{{artist}} — {{title}}\", \"alt\": \"{{status}}\", \"tooltip\": \"Title: {{title}}\\nArtist: {{artist}}\\nAlbum: {{album}}\\nStatus: {{status}}\"}' 2>/dev/null || echo '{\"text\": \"No Media Playing\", \"alt\": \"Paused\", \"tooltip\": \"No active media player\"}'",
      "on-click": "playerctl play-pause",
      "on-scroll-up": "playerctl next",
      "on-scroll-down": "playerctl previous",
      "max-length": 38
    },
    "custom/media-next": {
      "format": "󰒭",
      "tooltip-format": "Next Track",
      "on-click": "playerctl next"
    },
    "clock": {
      "format": "󰥔 {:%I:%M %p}",
      "format-alt": "󰃭 {:%A, %B %d, %Y  󰥔 %I:%M %p}",
      "tooltip-format": "<span size='18000' weight='bold' color='#89dceb'>  󰃭 {:%B %Y}</span>\n\n<tt><span size='15000'>{calendar}</span></tt>",
      "calendar": {
        "mode": "month",
        "mode-mon-col": 3,
        "weeks-pos": "right",
        "on-scroll": 1,
        "format": {
          "months": "<span color=\"#a6e3a1\"><b>{}</b></span>",
          "days": "<span color=\"#cdd6f4\"><b>{}</b></span>",
          "weeks": "<span color=\"#89dceb\"><b>W{}</b></span>",
          "weekdays": "<span color=\"#f9e2af\"><b>{}</b></span>",
          "today": "<span color=\"#f5c2e7\"><b><u>{}</u></b></span>"
        }
      },
      "actions": {
        "on-click-right": "mode",
        "on-scroll-up": "shift_up",
        "on-scroll-down": "shift_down"
      }
    },
    "pulseaudio": {
      "format": "{icon} {volume}%",
      "format-muted": "󰝟 Muted",
      "format-icons": {
        "headphone": "󰋋",
        "hands-free": "󰋎",
        "headset": "󰋎",
        "phone": "󰏲",
        "portable": "󰏲",
        "car": "󰄋",
        "default": ["󰕿", "󰖀", "󰕾"]
      },
      "scroll-step": 5,
      "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
      "on-click-right": "pavucontrol",
      "on-scroll-up": "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
      "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    },
    "cpu": {
      "format": " {usage}%",
      "interval": 2,
      "tooltip": true,
      "on-click": "wezterm start btop"
    },
    "memory": {
      "format": " {used:0.1f}G",
      "tooltip-format": "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)",
      "interval": 2,
      "on-click": "wezterm start btop"
    },
    "network": {
      "interval": 2,
      "format-wifi": "󰤨 󰇚{bandwidthDownBytes}",
      "format-ethernet": "󰈀 󰇚{bandwidthDownBytes}",
      "format-disconnected": "󰤮 Offline",
      "min-length": 14,
      "on-click": "wezterm start nmtui"
    },
    "battery": {
      "states": {
        "warning": 30,
        "critical": 15
      },
      "format": "{icon} {capacity}%",
      "format-charging": "󰂄 {capacity}%",
      "format-plugged": "󰚥 {capacity}%",
      "format-icons": ["󰂎", "󰁺", "󰁼", "󰁾", "󰂀", "󰁹"]
    },
    "tray": {
      "icon-size": 16,
      "spacing": 8
    },
    "custom/power": {
      "format": "󰐥",
      "tooltip-format": "Power Options",
      "on-click": "bash ~/.config/waybar/scripts/power-menu.sh"
    }
  },
  {
    "name": "secondary",
    "output": ["__SECONDARY__"],
    "layer": "top",
    "position": "top",
    "height": 36,
    "margin-top": 6,
    "margin-left": 12,
    "margin-right": 12,
    "spacing": 6,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["hyprland/window"],
    "modules-right": ["clock"],
    "hyprland/workspaces": {
      "all-outputs": false,
      "active-only": false,
      "on-click": "activate",
      "format": "{name}",
      "tooltip": true,
      "tooltip-format": "Workspace {name}\n{windows}"
    },
    "hyprland/window": {
      "format": "󰘔 {title}",
      "max-length": 32,
      "separate-outputs": true
    },
    "clock": {
      "format": "󰥔 {:%I:%M %p}",
      "format-alt": "󰃭 {:%A, %B %d, %Y  󰥔 %I:%M %p}",
      "tooltip-format": "<span size='18000' weight='bold' color='#89dceb'>  󰃭 {:%B %Y}</span>\n\n<tt><span size='15000'>{calendar}</span></tt>",
      "calendar": {
        "mode": "month",
        "mode-mon-col": 3,
        "weeks-pos": "right",
        "on-scroll": 1,
        "format": {
          "months": "<span color=\"#a6e3a1\"><b>{}</b></span>",
          "days": "<span color=\"#cdd6f4\"><b>{}</b></span>",
          "weeks": "<span color=\"#89dceb\"><b>W{}</b></span>",
          "weekdays": "<span color=\"#f9e2af\"><b>{}</b></span>",
          "today": "<span color=\"#f5c2e7\"><b><u>{}</u></b></span>"
        }
      },
      "actions": {
        "on-click-right": "mode",
        "on-scroll-up": "shift_up",
        "on-scroll-down": "shift_down"
      }
    }
  }
]
EOF
fi

# Launch Waybar
waybar -c "$DIR/config.jsonc" -s "$DIR/style.css" &
