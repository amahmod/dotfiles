#!/usr/bin/env bash

# System-Wide Theme Switcher
# Synchronizes theme across Neovim, Waybar, WezTerm, Thunar (GTK 3/4), Wofi, Wlogout, and Dunst

STATE_FILE="$HOME/.config/current_theme"
CURRENT_THEME=$(cat "$STATE_FILE" 2>/dev/null || echo "catppuccin-macchiato")

THEMES=("catppuccin-macchiato" "tokyo-night" "nord" "gruvbox-dark" "catppuccin-latte")

MODE="$1"

if [ -z "$MODE" ] || [ "$MODE" = "menu" ]; then
    CHOICE=$(echo -e "🍇 Catppuccin Macchiato\n🌃 Tokyo Night\n❄️ Nord\n🍂 Gruvbox Dark\n☀️ Catppuccin Latte" | wofi --dmenu --prompt "Select Theme" --width 320 --height 260)
    case "$CHOICE" in
        *"Catppuccin Macchiato"*) TARGET_THEME="catppuccin-macchiato" ;;
        *"Tokyo Night"*)          TARGET_THEME="tokyo-night" ;;
        *"Nord"*)                 TARGET_THEME="nord" ;;
        *"Gruvbox Dark"*)         TARGET_THEME="gruvbox-dark" ;;
        *"Catppuccin Latte"*)     TARGET_THEME="catppuccin-latte" ;;
        *) exit 0 ;;
    esac
elif [ "$MODE" = "next" ]; then
    INDEX=0
    for i in "${!THEMES[@]}"; do
        if [ "${THEMES[$i]}" = "$CURRENT_THEME" ]; then
            INDEX=$(( (i + 1) % ${#THEMES[@]} ))
            break
        fi
    done
    TARGET_THEME="${THEMES[$INDEX]}"
else
    TARGET_THEME="$MODE"
fi

case "$TARGET_THEME" in
    "catppuccin-macchiato")
        THEME_NAME="Catppuccin Macchiato"
        NVIM_SCHEME="catppuccin-macchiato"
        NVIM_BG="dark"
        WEZTERM_SCHEME="Catppuccin Macchiato"
        GTK_SCHEME="prefer-dark"
        MAIN_BG="rgba(15, 15, 23, 0.92)"
        MAIN_BG_HEX="#181825"
        MAIN_FG="#cdd6f4"
        ACCENT="#c6a0f6"
        ARCH_BG="#a6e3a1"
        CLOCK_COLOR="#89dceb"
        PULSE_BG="#f5c2e7"
        POWER_BG="#f38ba8"
        BORDER="#a6e3a1"
        ;;
    "tokyo-night")
        THEME_NAME="Tokyo Night"
        NVIM_SCHEME="tokyonight-night"
        NVIM_BG="dark"
        WEZTERM_SCHEME="Tokyo Night"
        GTK_SCHEME="prefer-dark"
        MAIN_BG="rgba(26, 27, 38, 0.94)"
        MAIN_BG_HEX="#1a1b26"
        MAIN_FG="#c0caf5"
        ACCENT="#7aa2f7"
        ARCH_BG="#7dcfff"
        CLOCK_COLOR="#7aa2f7"
        PULSE_BG="#bb9af7"
        POWER_BG="#f7768e"
        BORDER="#7aa2f7"
        ;;
    "nord")
        THEME_NAME="Nord"
        NVIM_SCHEME="nord"
        NVIM_BG="dark"
        WEZTERM_SCHEME="Nord"
        GTK_SCHEME="prefer-dark"
        MAIN_BG="rgba(46, 52, 64, 0.94)"
        MAIN_BG_HEX="#2e3440"
        MAIN_FG="#eceff4"
        ACCENT="#88c0d0"
        ARCH_BG="#a3be8c"
        CLOCK_COLOR="#81a1c1"
        PULSE_BG="#b48ead"
        POWER_BG="#bf616a"
        BORDER="#88c0d0"
        ;;
    "gruvbox-dark")
        THEME_NAME="Gruvbox Dark"
        NVIM_SCHEME="gruvbox"
        NVIM_BG="dark"
        WEZTERM_SCHEME="Gruvbox dark, hard"
        GTK_SCHEME="prefer-dark"
        MAIN_BG="rgba(40, 40, 40, 0.94)"
        MAIN_BG_HEX="#282828"
        MAIN_FG="#ebdbb2"
        ACCENT="#fe8019"
        ARCH_BG="#b8bb26"
        CLOCK_COLOR="#83a598"
        PULSE_BG="#d3869b"
        POWER_BG="#fb4934"
        BORDER="#fe8019"
        ;;
    "catppuccin-latte")
        THEME_NAME="Catppuccin Latte"
        NVIM_SCHEME="catppuccin-latte"
        NVIM_BG="light"
        WEZTERM_SCHEME="Catppuccin Latte"
        GTK_SCHEME="prefer-light"
        MAIN_BG="rgba(239, 241, 245, 0.96)"
        MAIN_BG_HEX="#eff1f5"
        MAIN_FG="#4c4f69"
        ACCENT="#8839ef"
        ARCH_BG="#40a02b"
        CLOCK_COLOR="#179299"
        PULSE_BG="#ea76cb"
        POWER_BG="#d20f39"
        BORDER="#8839ef"
        ;;
    *)
        echo "Unknown theme: $TARGET_THEME"
        exit 1
        ;;
esac

# Save state
echo "$TARGET_THEME" > "$STATE_FILE"

# 1. Update Neovim configuration & live instances
mkdir -p "$HOME/.config/nvim/lua"
cat << EOF > "$HOME/.config/nvim/lua/current_theme.lua"
vim.o.background = "$NVIM_BG"
vim.cmd.colorscheme("$NVIM_SCHEME")
EOF

for sock in /tmp/nvim* /run/user/"$UID"/nvim* /tmp/nvim.*/0; do
    if [ -S "$sock" ]; then
        nvim --server "$sock" --remote-send "<Cmd>luafile $HOME/.config/nvim/lua/current_theme.lua<CR>" 2>/dev/null || true
    fi
done

# 2. Update WezTerm
mkdir -p "$HOME/.config/wezterm"
cat << EOF > "$HOME/.config/wezterm/theme.lua"
return { color_scheme = '$WEZTERM_SCHEME' }
EOF

# 3. Update GTK 3 & GTK 4 (Thunar, etc.)
if [ "$GTK_SCHEME" = "prefer-dark" ]; then
    DARK_VAL=1
else
    DARK_VAL=0
fi

gsettings set org.gnome.desktop.interface color-scheme "$GTK_SCHEME" 2>/dev/null || true

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat << EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Adwaita
gtk-application-prefer-dark-theme=$DARK_VAL
gtk-font-name=JetBrainsMono Nerd Font 10
EOF
cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

cat << EOF > "$HOME/.config/gtk-3.0/gtk.css"
@define-color theme_bg_color $MAIN_BG_HEX;
@define-color theme_fg_color $MAIN_FG;
@define-color theme_selected_bg_color $ACCENT;
@define-color theme_selected_fg_color #ffffff;
@define-color theme_base_color $MAIN_BG_HEX;
@define-color theme_text_color $MAIN_FG;

window, window.background, .sidebar, treeview, iconview, scrolledwindow, toolbar, headerbar, .view, .thunar, viewport {
    background-color: $MAIN_BG_HEX;
    color: $MAIN_FG;
}

treeview:selected, iconview:selected, .sidebar row:selected, entry:selected {
    background-color: $ACCENT;
    color: #11111b;
}

entry, searchbar {
    background-color: rgba(255, 255, 255, 0.05);
    color: $MAIN_FG;
    border: 1px solid $ACCENT;
}
EOF
cp "$HOME/.config/gtk-3.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

# Kill Thunar daemon process to force instant refresh on launch
thunar -q 2>/dev/null || true

# 4. Update Waybar Colors & Reload
mkdir -p "$HOME/.config/waybar"
cat << EOF > "$HOME/.config/waybar/colors.css"
@define-color main-bg $MAIN_BG;
@define-color main-fg $MAIN_FG;
@define-color accent $ACCENT;
@define-color arch-bg $ARCH_BG;
@define-color clock-color $CLOCK_COLOR;
@define-color pulseaudio-bg $PULSE_BG;
@define-color power-bg $POWER_BG;
@define-color border-color $BORDER;
EOF

bash "$HOME/.config/waybar/launch.sh" 2>/dev/null || true

# 5. Update Wofi Styling
mkdir -p "$HOME/.config/wofi"
cat << EOF > "$HOME/.config/wofi/style.css"
window {
    background-color: $MAIN_BG_HEX;
    border: 2px solid $ACCENT;
    border-radius: 14px;
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
}

#input {
    margin: 10px;
    border-radius: 10px;
    border: 1px solid $ACCENT;
    background-color: rgba(255, 255, 255, 0.05);
    color: $MAIN_FG;
}

#entry {
    margin: 4px 10px;
    border-radius: 8px;
    color: $MAIN_FG;
}

#entry:selected {
    background-color: $ACCENT;
    color: #11111b;
}
EOF

# 6. Update Wlogout Styling
mkdir -p "$HOME/.config/wlogout"
cat << EOF > "$HOME/.config/wlogout/style.css"
* {
    background-image: none;
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 15px;
    font-weight: bold;
    box-shadow: none;
}

window {
    background-color: $MAIN_BG;
}

button {
    color: $MAIN_FG;
    background-color: rgba(255, 255, 255, 0.08);
    border: 2px solid $ACCENT;
    border-radius: 20px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 28%;
    margin: 14px;
    padding: 24px;
    transition: all 0.3s ease;
}

button:focus, button:active, button:hover {
    background-color: $ACCENT;
    color: #11111b;
    box-shadow: 0 0 24px $ACCENT;
}

#lock { background-image: image(url("/usr/share/wlogout/icons/lock.png")); }
#logout { background-image: image(url("/usr/share/wlogout/icons/logout.png")); }
#suspend { background-image: image(url("/usr/share/wlogout/icons/suspend.png")); }
#hibernate { background-image: image(url("/usr/share/wlogout/icons/hibernate.png")); }
#shutdown { background-image: image(url("/usr/share/wlogout/icons/shutdown.png")); border-color: $POWER_BG; color: $POWER_BG; }
#reboot { background-image: image(url("/usr/share/wlogout/icons/reboot.png")); border-color: $ACCENT; color: $ACCENT; }
EOF

# Notify user
if command -v notify-send &>/dev/null; then
    notify-send "System Theme Changed" "Switched active theme to <b>$THEME_NAME</b>" -i preferences-desktop-theme
fi
