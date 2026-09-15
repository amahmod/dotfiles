#!/usr/bin/env bash

set -e 

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
	git \
	stow \
	hyprland \
	kitty \
	sddm 

if [[ -f "$HOME/.bash_profile" && ! -L "$HOME/.bash_profile" ]]; then
	mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
fi

cd "$REPO_DIR"
stow --target="$HOME" config
