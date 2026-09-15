#!/usr/bin/env bash

# Directory of Waybar config
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terminate existing Waybar instances
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
else
    PRIMARY="${MONITORS[0]}"
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
    # Workspaces 1-9 on primary monitor
    for w in $(seq 1 9); do
        is_default="false"
        [ "$w" -eq 1 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$PRIMARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    cat << EOF > "$DIR/config.jsonc"
{
  "name": "main",
  "output": ["$PRIMARY"],
  "layer": "top",
  "position": "top",
  "height": 32,
  "margin-top": 4,
  "margin-left": 8,
  "margin-right": 8,
  "spacing": 4,
  "modules-left": ["hyprland/workspaces", "hyprland/window"],
  "modules-center": ["clock", "custom/uptime"],
  "modules-right": ["cpu", "memory", "network", "pulseaudio"$BATTERY_MODULE, "tray"],
  "hyprland/workspaces": {
    "all-outputs": false,
    "active-only": false,
    "on-click": "activate",
    "format": "{name}"
  },
  "hyprland/window": {
    "format": "{title}",
    "max-length": 45,
    "separate-outputs": true
  },
  "clock": {
    "format": " {:%I:%M %p}",
    "format-alt": " {:%a %d/%m   %I:%M %p}",
    "tooltip-format": "<tt><small>{calendar}</small></tt>",
    "calendar": {
      "mode": "month",
      "mode-mon-col": 3,
      "weeks-pos": "right",
      "format": {
        "months": "<span color='#c6a0f6'><b>{}</b></span>",
        "days": "<span color='#cad3f5'><b>{}</b></span>",
        "weeks": "<span color='#8bd5ca'><b>W{}</b></span>",
        "weekdays": "<span color='#eed49f'><b>{}</b></span>",
        "today": "<span color='#ed8796'><b><u>{}</u></b></span>"
      }
    }
  },
  "custom/uptime": {
    "format": " {}",
    "interval": 60,
    "exec": "uptime -p | sed 's/up //;s/ days/d/;s/ day/d/;s/ hours/h/;s/ hour/h/;s/ minutes/m/;s/ minute/m/'",
    "tooltip": false
  },
  "cpu": {
    "format": " {usage}%",
    "interval": 2,
    "tooltip": true
  },
  "memory": {
    "format": " {used:0.1f}G",
    "tooltip-format": "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB",
    "interval": 2
  },
  "network": {
    "format-wifi": " {essid}",
    "format-ethernet": "󰈀 {ipaddr}",
    "format-disconnected": "󰤮 Disconnected",
    "tooltip-format-wifi": "SSID: {essid} ({signalStrength}%)\nIP: {ipaddr}\nGW: {gwaddr}",
    "tooltip-format-ethernet": "Interface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}",
    "tooltip-format-disconnected": "Network disconnected",
    "on-click": "wezterm start nmtui"
  },
  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "婢 Muted",
    "format-icons": {
      "headphone": "",
      "hands-free": "",
      "headset": "",
      "phone": "",
      "portable": "",
      "car": "",
      "default": ["", "", ""]
    },
    "scroll-step": 5,
    "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    "on-click-right": "pavucontrol",
    "on-scroll-up": "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
    "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  },
  "battery": {
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "{icon} {capacity}%",
    "format-charging": "󰂄 {capacity}%",
    "format-plugged": " {capacity}%",
    "format-icons": ["", "", "", "", ""]
  },
  "tray": {
    "icon-size": 16,
    "spacing": 8
  }
}
EOF

else
    # --- Multi-Monitor Mode (2+ Monitors) ---
    SECONDARY="${MONITORS[1]}"

    # Primary gets workspaces 1-5
    for w in $(seq 1 5); do
        is_default="false"
        [ "$w" -eq 1 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$PRIMARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    # Secondary gets workspaces 6-9
    for w in $(seq 6 9); do
        is_default="false"
        [ "$w" -eq 6 ] && is_default="true"
        hyprctl eval "hl.workspace_rule({ workspace = '$w', monitor = '$SECONDARY', default = $is_default, persistent = true })" > /dev/null 2>&1 || true
    done

    cat << EOF > "$DIR/config.jsonc"
[
  {
    "name": "primary",
    "output": ["$PRIMARY"],
    "layer": "top",
    "position": "top",
    "height": 32,
    "margin-top": 4,
    "margin-left": 8,
    "margin-right": 8,
    "spacing": 4,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock", "custom/uptime"],
    "modules-right": ["cpu", "memory", "network", "pulseaudio"$BATTERY_MODULE, "tray"],
    "hyprland/workspaces": {
      "all-outputs": false,
      "active-only": false,
      "on-click": "activate",
      "format": "{name}"
    },
    "hyprland/window": {
      "format": "{title}",
      "max-length": 45,
      "separate-outputs": true
    },
    "clock": {
      "format": " {:%I:%M %p}",
      "format-alt": " {:%a %d/%m   %I:%M %p}",
      "tooltip-format": "<tt><small>{calendar}</small></tt>",
      "calendar": {
        "mode": "month",
        "mode-mon-col": 3,
        "weeks-pos": "right",
        "format": {
          "months": "<span color='#c6a0f6'><b>{}</b></span>",
          "days": "<span color='#cad3f5'><b>{}</b></span>",
          "weeks": "<span color='#8bd5ca'><b>W{}</b></span>",
          "weekdays": "<span color='#eed49f'><b>{}</b></span>",
          "today": "<span color='#ed8796'><b><u>{}</u></b></span>"
        }
      }
    },
    "custom/uptime": {
      "format": " {}",
      "interval": 60,
      "exec": "uptime -p | sed 's/up //;s/ days/d/;s/ day/d/;s/ hours/h/;s/ hour/h/;s/ minutes/m/;s/ minute/m/'",
      "tooltip": false
    },
    "cpu": {
      "format": " {usage}%",
      "interval": 2,
      "tooltip": true
    },
    "memory": {
      "format": " {used:0.1f}G",
      "tooltip-format": "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB",
      "interval": 2
    },
    "network": {
      "format-wifi": " {essid}",
      "format-ethernet": "󰈀 {ipaddr}",
      "format-disconnected": "󰤮 Disconnected",
      "tooltip-format-wifi": "SSID: {essid} ({signalStrength}%)\nIP: {ipaddr}\nGW: {gwaddr}",
      "tooltip-format-ethernet": "Interface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}",
      "tooltip-format-disconnected": "Network disconnected",
      "on-click": "wezterm start nmtui"
    },
    "pulseaudio": {
      "format": "{icon} {volume}%",
      "format-muted": "婢 Muted",
      "format-icons": {
        "headphone": "",
        "hands-free": "",
        "headset": "",
        "phone": "",
        "portable": "",
        "car": "",
        "default": ["", "", ""]
      },
      "scroll-step": 5,
      "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
      "on-click-right": "pavucontrol",
      "on-scroll-up": "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
      "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    },
    "battery": {
      "states": {
        "warning": 30,
        "critical": 15
      },
      "format": "{icon} {capacity}%",
      "format-charging": "󰂄 {capacity}%",
      "format-plugged": " {capacity}%",
      "format-icons": ["", "", "", "", ""]
    },
    "tray": {
      "icon-size": 16,
      "spacing": 8
    }
  },
  {
    "name": "secondary",
    "output": ["$SECONDARY"],
    "layer": "top",
    "position": "top",
    "height": 32,
    "margin-top": 4,
    "margin-left": 8,
    "margin-right": 8,
    "spacing": 4,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio"],
    "hyprland/workspaces": {
      "all-outputs": false,
      "active-only": false,
      "on-click": "activate",
      "format": "{name}"
    },
    "hyprland/window": {
      "format": "{title}",
      "max-length": 45,
      "separate-outputs": true
    },
    "clock": {
      "format": " {:%I:%M %p}",
      "format-alt": " {:%a %d/%m   %I:%M %p}",
      "tooltip-format": "<tt><small>{calendar}</small></tt>"
    },
    "pulseaudio": {
      "format": "{icon} {volume}%",
      "format-muted": "婢 Muted",
      "format-icons": {
        "headphone": "",
        "hands-free": "",
        "headset": "",
        "phone": "",
        "portable": "",
        "car": "",
        "default": ["", "", ""]
      },
      "scroll-step": 5,
      "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
      "on-click-right": "pavucontrol",
      "on-scroll-up": "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
      "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    }
  }
]
EOF

fi

# Start Waybar if installed
if command -v waybar &>/dev/null; then
    nohup waybar -c "$DIR/config.jsonc" -s "$DIR/style.css" >/dev/null 2>&1 &
fi
