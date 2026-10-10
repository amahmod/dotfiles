[[ -f ~/.bashrc ]] &&  . ~/.bashrc

# Shared aliases (also used by zsh)
[ -f "$HOME/.config/aliasrc" ] && . "$HOME/.config/aliasrc"


# if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
# 	exec Hyprland
# fi


# Added by Antigravity CLI installer
export PATH="/home/amahmod/.local/bin:$PATH"

export TERMINAL="wezterm"

# Input Method (IBus / Wayland IME support for Avro Phonetic & Multilingual Input)
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export SDL_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus
export INPUT_METHOD=ibus


