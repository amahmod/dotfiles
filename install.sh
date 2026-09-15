#!/usr/bin/env bash

set -eo pipefail

# --- Visual Styling & Colors ---
BOLD="\033[1m"
RESET="\033[0m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
PURPLE="\033[35m"

log_step()    { echo -e "\n${BOLD}${PURPLE}==>${RESET} ${BOLD}$1${RESET}"; }
log_info()    { echo -e "  ${CYAN}ℹ${RESET} $1"; }
log_success() { echo -e "  ${GREEN}✔${RESET} $1"; }
log_warn()    { echo -e "  ${YELLOW}▲${RESET} $1"; }
log_error()   { echo -e "  ${RED}✖${RESET} $1"; }

# --- Safety & Privilege Checks ---
if [[ "$EUID" -eq 0 ]]; then
    log_error "Please do not run this script as root/sudo directly (makepkg will fail)."
    log_info "Run it as your normal user. The script will request sudo when required."
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
START_TIME=$(date +%s)

# Cleanup trap for temporary files
TMP_DIR=""
cleanup() {
    if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
        rm -rf "$TMP_DIR"
    fi
}
trap cleanup EXIT INT TERM

# --- Header Banner ---
echo -e "${CYAN}${BOLD}"
cat << "EOF"
    /\         Arch Linux + Hyprland Setup
   /  \        ---------------------------
  /\   \       Personal Dotfiles & Environment Installer
 /      \
/   ,,   \
EOF
echo -e "${RESET}"

# --- Keep sudo alive ---
log_step "Authenticating sudo credentials..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- Package Lists ---
OFFICIAL_PACKAGES=(
    base-devel
    git
    stow
    hyprland
    kitty
    wezterm
    sddm
    wofi
)

FONT_PACKAGES=(
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    otf-font-awesome
    noto-fonts
    noto-fonts-emoji
)

AUR_PACKAGES=(
    otf-symbola
)

# --- 1. System Update & Official Packages ---
log_step "Updating system and installing core packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}" "${FONT_PACKAGES[@]}"
log_success "Core packages and fonts installed."

# --- 2. AUR Helper (yay) & AUR Packages ---
log_step "Checking AUR helper (yay)..."
if command -v yay &> /dev/null; then
    log_success "yay is already installed."
else
    log_info "Compiling and installing yay..."
    TMP_DIR="$(mktemp -d)"
    git clone --depth=1 https://aur.archlinux.org/yay.git "$TMP_DIR/yay"
    (cd "$TMP_DIR/yay" && makepkg -si --noconfirm)
    log_success "yay installed successfully."
fi

if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
    log_step "Installing AUR packages..."
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
    log_success "AUR packages installed."
fi

log_step "Updating font cache..."
fc-cache -f > /dev/null
log_success "Font cache updated."

# --- 3. Dotfiles Deployment (Stow) ---
log_step "Deploying dotfiles with GNU Stow..."

# Backup .bash_profile if it's a regular file (not a symlink)
if [[ -f "$HOME/.bash_profile" && ! -L "$HOME/.bash_profile" ]]; then
    log_info "Backing up existing ~/.bash_profile to ~/.bash_profile.bak"
    mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
fi

# Ensure ~/.config exists as a real directory to prevent tree folding
mkdir -p "$HOME/.config"
(cd "$REPO_DIR" && stow -R --no-folding --target="$HOME" config)
log_success "Dotfiles linked to $HOME."

# --- 4. Services ---
log_step "Configuring system services..."
if ! systemctl is-enabled --quiet sddm 2>/dev/null; then
    sudo systemctl enable sddm
    log_success "SDDM display manager enabled."
else
    log_info "SDDM is already enabled."
fi

# --- Summary ---
ELAPSED=$(( $(date +%s) - START_TIME ))
echo -e "\n${BOLD}${GREEN}==========================================="
echo -e "  ✔ Installation Complete! (${ELAPSED}s)"
echo -e "===========================================${RESET}"
echo -e "  Keybindings:"
echo -e "    ${CYAN}SUPER + Return${RESET} : Terminal (Wezterm)"
echo -e "    ${CYAN}SUPER + Space${RESET}  : App Launcher (Wofi)"
echo -e "    ${CYAN}SUPER + Q${RESET}      : Close Window"
echo -e "    ${CYAN}SUPER + M${RESET}      : Exit Hyprland\n"
