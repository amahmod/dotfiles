#!/usr/bin/env sh
# Profile file. Runs on login.

# Adds `~/.local/bin/` and all subdirectories to $PATH
export PATH="$PATH:$(find -L "$HOME/.local/bin/"  -type d | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:/opt/Upwork"
export PATH="$PATH:/opt/freelancer-desktop-app/bin"
export CODEEDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="google-chrome-stable"
export READER="zathura"
export FILE="lf"
export WM="bspwm"
export PAGER="less"

# less/man colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep bspwm || startx
fi
