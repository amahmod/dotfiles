[[ -f ~/.bashrc ]] &&  . ~/.bashrc

# Shared aliases (also used by zsh)
[ -f "$HOME/.config/aliasrc" ] && . "$HOME/.config/aliasrc"


# if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
# 	exec Hyprland
# fi


# Added by Antigravity CLI installer
export PATH="/home/amahmod/.local/bin:$PATH"

export TERMINAL="wezterm"
