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

log_step() { echo -e "\n${BOLD}${PURPLE}==>${RESET} ${BOLD}$1${RESET}"; }
log_info() { echo -e "  ${CYAN}ℹ${RESET} $1"; }
log_success() { echo -e "  ${GREEN}✔${RESET} $1"; }
log_warn() { echo -e "  ${YELLOW}▲${RESET} $1"; }
log_error() { echo -e "  ${RED}✖${RESET} $1"; }

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
cat <<"EOF"
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
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# --- Package Lists ---
OFFICIAL_PACKAGES=(
    ansible
    base-devel
    git
    less
    openssh
    pciutils
    stow
    hyprland
    kitty
    wezterm
    sddm
    wofi
    zsh
    starship
    gtop
    zsh-autosuggestions
    zsh-syntax-highlighting
)

FONT_PACKAGES=(
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    otf-font-awesome
    noto-fonts
    noto-fonts-emoji
)

DESKTOP_UTILS=(
    # Notifications & Desktop Management
    dunst
    libnotify
    glib2

    # Audio & Screensharing
    pipewire
    wireplumber
    pipewire-audio
    pipewire-pulse

    # XDG Desktop Portals
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Polkit Authentication Agent
    hyprpolkitagent

    # Qt Wayland Support
    qt5-wayland
    qt6-wayland

    # Screenshots & Clipboard
    grim
    slurp
    wl-clipboard
    wtype
    swappy
    satty

    # File Management & Previews
    yazi
    thunar
    thunar-volman
    thunar-archive-plugin
    file-roller
    tumbler
    gvfs
    ffmpegthumbnailer
    poppler
    zathura
    zathura-pdf-mupdf
    imv
    fd
    ripgrep
    fzf
    zoxide
    jq
    imagemagick

    # Wallpaper, Bar & Media Controls
    awww
    waybar
    mpv
    pavucontrol
    brightnessctl
    playerctl
    btop

    # Editor, Linting, & Git Tools
    neovim
    nodejs
    npm
    biome
    tree-sitter
    tree-sitter-cli
    lazygit
    stylua
    shfmt
    shellcheck
    luacheck
    python-pynvim
    python-pip
    unzip
    wget
    zip
)

PHONE_TRANSFER_PACKAGES=(
    # Android High-Speed ADB & Universal Device Rules
    android-tools           # ADB & Fastboot for max USB/Wi-Fi transfer speed
    android-udev            # Udev rules for all Android phones (non-root access)
    scrcpy                  # Screen mirror & drag-drop file transfer

    # Android MTP & Camera GUI Support (Thunar / GVFS)
    gvfs-mtp                # MTP backend for Thunar & GVFS to browse Android
    gvfs-gphoto2            # PTP camera protocol backend

    # Apple iOS Device Support
    usbmuxd                 # USB multiplexer daemon for iOS
    libimobiledevice        # iOS communication protocol library
    ifuse                   # FUSE filesystem driver for iPhone/iPad
    gvfs-afc                # AFC backend for Thunar to browse iOS files

    # Network & Terminal Transfer Utilities
    qrencode                # Generates terminal QR codes for instant mobile sharing
)

AUR_PACKAGES=(
    otf-symbola
    zsh-vi-mode
    wlogout
    wofi-emoji
    localsend-bin           # Cross-platform AirDrop alternative over local Wi-Fi
    simple-mtpfs            # FUSE driver for direct MTP mounting
)

# --- 1. GPU Detection & Driver Selection ---
log_step "Detecting GPU hardware..."
GPU_PACKAGES=(
    mesa
    mesa-utils
    vulkan-tools
    libva-utils
)

GPU_INFO=$(lspci -k 2>/dev/null | grep -iE "(vga|3d|display)" || true)

if echo "$GPU_INFO" | grep -iE "amd|radeon|advanced micro devices" &>/dev/null; then
    log_info "Detected AMD GPU."
    GPU_PACKAGES+=(
        vulkan-radeon
        xf86-video-amdgpu
    )
fi

if echo "$GPU_INFO" | grep -iE "intel" &>/dev/null; then
    log_info "Detected Intel GPU."
    GPU_PACKAGES+=(
        vulkan-intel
        intel-media-driver
    )
fi

if echo "$GPU_INFO" | grep -iE "nvidia" &>/dev/null; then
    log_info "Detected NVIDIA GPU."
    GPU_PACKAGES+=(
        nvidia-open-dkms
        nvidia-utils
        egl-wayland
    )
fi

# --- 2. System Update & Official Packages ---
log_step "Updating system and installing core packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    "${OFFICIAL_PACKAGES[@]}" \
    "${FONT_PACKAGES[@]}" \
    "${DESKTOP_UTILS[@]}" \
    "${PHONE_TRANSFER_PACKAGES[@]}" \
    "${GPU_PACKAGES[@]}"
log_success "Core packages, GPU drivers, fonts, desktop utilities, and mobile transfer tools installed."

# --- 3. AUR Helper (yay) & AUR Packages ---
log_step "Checking AUR helper (yay)..."
if command -v yay &>/dev/null; then
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

# Fallback setup for zsh-vi-mode if not installed via system package
if [[ ! -d "$HOME/.local/share/zsh-vi-mode" && ! -f "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
    log_info "Cloning zsh-vi-mode plugin..."
    git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode.git "$HOME/.local/share/zsh-vi-mode" 2>/dev/null || true
fi

# --- 4. SSH Keys & Private Fonts ---
log_step "Configuring SSH keys and private fonts..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/id_rsa" && -f "$REPO_DIR/.keys/id_rsa" ]]; then
    log_info "Decrypting SSH private key with Ansible Vault..."
    ansible-vault decrypt "$REPO_DIR/.keys/id_rsa" --output "$HOME/.ssh/id_rsa"
    chmod 600 "$HOME/.ssh/id_rsa"
    if [[ -f "$REPO_DIR/.keys/id_rsa.pub" ]]; then
        cp "$REPO_DIR/.keys/id_rsa.pub" "$HOME/.ssh/id_rsa.pub"
        chmod 644 "$HOME/.ssh/id_rsa.pub"
    fi
    log_success "SSH key deployed to ~/.ssh/id_rsa."
elif [[ -f "$HOME/.ssh/id_rsa" ]]; then
    log_info "SSH key already exists at ~/.ssh/id_rsa."
fi

mkdir -p "$HOME/.local/share/fonts"
if [[ ! -d "$HOME/.local/share/fonts/private-fonts" && ! -d "$HOME/.local/share/fonts/.git" ]]; then
    if [[ -f "$HOME/.ssh/id_rsa" ]]; then
        log_info "Cloning private fonts repository..."
        touch "$HOME/.ssh/known_hosts"
        ssh-keyscan -H github.com >>"$HOME/.ssh/known_hosts" 2>/dev/null || true
        GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa -o StrictHostKeyChecking=accept-new" \
            git clone git@github.com:amahmod/fonts.git "$HOME/.local/share/fonts/private-fonts"
        log_success "Private fonts repository cloned."
    else
        log_warn "SSH key (~/.ssh/id_rsa) not found. Skipping private fonts clone."
    fi
else
    log_info "Private fonts already present."
fi

log_step "Updating font cache..."
fc-cache -f >/dev/null
log_success "Font cache updated."

# --- 5. Dotfiles Deployment (Stow) ---
log_step "Deploying dotfiles with GNU Stow..."

# Backup .bash_profile if it's a regular file (not a symlink)
if [[ -f "$HOME/.bash_profile" && ! -L "$HOME/.bash_profile" ]]; then
    log_info "Backing up existing ~/.bash_profile to ~/.bash_profile.bak"
    mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
fi

# Backup .zshrc if it's a regular file (not a symlink)
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    log_info "Backing up existing ~/.zshrc to ~/.zshrc.bak"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Backup Thunar uca.xml if it's a regular file (not a symlink)
if [[ -f "$HOME/.config/Thunar/uca.xml" && ! -L "$HOME/.config/Thunar/uca.xml" ]]; then
    log_info "Backing up existing ~/.config/Thunar/uca.xml to ~/.config/Thunar/uca.xml.bak"
    mv "$HOME/.config/Thunar/uca.xml" "$HOME/.config/Thunar/uca.xml.bak"
fi

# Ensure target directories exist as real directories to prevent tree folding
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
(cd "$REPO_DIR" && stow -R --no-folding --target="$HOME" config)
log_success "Dotfiles linked to $HOME."

# Set default user shell to Zsh if installed
if [[ "$SHELL" != */zsh ]] && command -v zsh &>/dev/null; then
    log_info "Setting default user shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || true
    log_success "Default shell set to zsh."
fi

# --- 6. Services & Device Permissions ---
log_step "Configuring system services and permissions..."
if ! systemctl is-enabled --quiet sddm 2>/dev/null; then
    sudo systemctl enable sddm
    log_success "SDDM display manager enabled."
else
    log_info "SDDM is already enabled."
fi

# Configure Android udev rules and non-root user permissions
log_info "Configuring Android udev rules and user groups..."
if ! getent group adbusers >/dev/null 2>&1; then
    sudo groupadd -f adbusers
fi
if ! id -nG "$USER" | grep -qw "adbusers"; then
    log_info "Adding $USER to 'adbusers' group for non-root ADB access..."
    sudo usermod -aG adbusers "$USER"
    log_success "User added to adbusers group."
fi
sudo udevadm control --reload-rules 2>/dev/null || true
sudo udevadm trigger 2>/dev/null || true

# Enable usbmuxd service for Apple iOS device support if present
if systemctl list-unit-files usbmuxd.service &>/dev/null; then
    if ! systemctl is-enabled --quiet usbmuxd 2>/dev/null; then
        sudo systemctl enable usbmuxd.service 2>/dev/null || true
        log_success "usbmuxd (iOS support) service enabled."
    fi
fi

# --- Summary ---
ELAPSED=$(($(date +%s) - START_TIME))
echo -e "\n${BOLD}${GREEN}==========================================="
echo -e "  ✔ Installation Complete! (${ELAPSED}s)"
echo -e "===========================================${RESET}"
echo -e "  Core Keybindings:
    ${CYAN}SUPER + Return${RESET}       : Terminal (Wezterm)
    ${CYAN}SUPER + Space${RESET}        : App Launcher (Wofi)
    ${CYAN}SUPER + E${RESET}            : Terminal File Manager (Yazi)
    ${CYAN}SUPER + Shift + E${RESET}    : GUI File Manager (Thunar)
    ${CYAN}SUPER + Q${RESET}            : Close Window
    ${CYAN}SUPER + Alt + Q${RESET}      : Exit Hyprland

  📱 Phone & Mobile File Transfer:
    ${CYAN}phone-transfer (pt)${RESET}   : High-Speed CLI Transfer & Web QR Share
    ${CYAN}phone-mount (pm)${RESET}      : Mount Phone to ~/Phone for Yazi & Terminal
    ${CYAN}In Thunar (GUI)${RESET}       : Sidebar Devices for MTP | Right-click -> Send to Phone
    ${CYAN}In Yazi (TUI)${RESET}         : 'g p' (Go to Phone), 'm p' (Push file), 'm c' (Pull photos)
    ${CYAN}SUPER + O, L${RESET}         : Launch LocalSend (Cross-Platform AirDrop)
    ${CYAN}SUPER + T, P${RESET}         : Launch Phone Transfer CLI\n"

