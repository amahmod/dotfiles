#!/usr/bin/env bash

set -e 

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
	git \
	base-devel \
	stow \
	hyprland \
	kitty \
	sddm \
	wofi

if command yay -v yay > /dev/null 2>&1; then
	echo "Yay already installed"
else
	echo "Installing yay..."
	TMP_DIR="$(mktemp -d)"

	git clone https://aur.archlinux.org/yay.git "$TMP_DIR/yay"
	cd "$TMP_DIR/yay"
	makepkg -si --noconfirm
	
	cd "$REPO_DIR"
	rm -rf "$TMP_DIR"

	echo "yay installed..."
fi


if [[ -f "$HOME/.bash_profile" && ! -L "$HOME/.bash_profile" ]]; then
	mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
fi

# Ensure ~/.config is a real directory to prevent stow from folding ~/.config into a symlink
mkdir -p "$HOME/.config"

cd "$REPO_DIR"
stow --no-folding --target="$HOME" config

sudo systemctl enable sddm
