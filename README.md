# ❄️ Arch Linux + Hyprland Dotfiles Setup

A minimal, high-performance, and beautifully crafted Arch Linux desktop environment powered by **Hyprland**, **WezTerm**, **Neovim**, **Waybar**, and **Yazi**. Includes an automated installer, dynamic multi-monitor management, system-wide live theme switching, and developer-grade formatting and linting workflows.

---

## 🌟 Key Features

- **🚀 Hyprland Lua Configuration (`hyprland.lua`)**
  - Modern Lua-configured Hyprland setup.
  - Automated multi-monitor detection with workspace splitting (Workspaces 1–5 on Primary, 6–10 on Secondary).
  - Native window rules, layer blur (Waybar), vim hjkl focus navigation, and custom media keybindings.
- **🎨 System-Wide Live Theme Switcher (`theme-switch.sh`)**
  - Switch entire system themes on the fly (`SUPER + SHIFT + T` for Wofi menu, `SUPER + ALT + T` for fast cycle).
  - Synchronizes **Neovim**, **WezTerm**, **Waybar**, **GTK 3/4 (Thunar)**, **Wofi**, **Wlogout**, and **Dunst**.
  - **Presets:** Catppuccin Macchiato, Tokyo Night, Nord, Gruvbox Dark, and Catppuccin Latte.
- **✨ Terminal Opacity Toggle (`SUPER + SHIFT + O`)**
  - Instant live toggle between **Solid 100% (Solid)** and **85% Translucent** terminal background (`opacity.lua`).
  - Native transparent background inheritance across **Zsh**, **Neovim**, and **Yazi** for seamless visual consistency.
- **⚡ Waybar Multi-Theme Control Center**
  - Multi-monitor top bar with atomic process locking (`flock`) to prevent duplicate instances.
  - Interactive media player widgets, volume control (`wpctl`), system resource monitors (`btop`), and Wofi/Wlogout integration.
- **💻 Neovim IDE Setup**
  - Uses Neovim 0.12 native LSP API (`vim.lsp.config` & `vim.lsp.enable`).
  - Fast autocompletion via `blink.cmp`.
  - Automated formatting via `conform.nvim` (`StyLua`, `Biome`, `Ruff`, `shfmt`) with `<leader>lf` format shortcut and auto-format on save.
  - Asynchronous linting via `nvim-lint` (`luacheck`, `shellcheck`, `biomejs`).
- **📁 Yazi Terminal File Manager**
  - Restricts `l` key navigation to open files like `Enter`.
  - Integrated MPV video launcher (`open-mpv.sh`).
  - Transparent theme integration matching terminal background.
- **🛠️ Fully Automated Installer (`install.sh`)**
  - Automatic GPU hardware detection (AMD, Intel, NVIDIA drivers & VA-API video acceleration).
  - Package installation via `pacman` and `yay` (AUR helper).
  - Automated Ansible Vault decryption for SSH keys (`.keys/id_rsa`).
  - Private font repository cloning and GNU Stow dotfile deployment.

---

## 📦 Managed Configuration Directory

```
.arch_setup/
├── install.sh                     # Automated installation script
├── config/
│   ├── .bash_profile              # Shell launch profile
│   ├── .zshrc                     # Zsh configuration (Starship, Vi mode, zoxide)
│   └── .config/
│       ├── dunst/                 # Notification daemon config
│       ├── hypr/
│       │   ├── hyprland.lua       # Hyprland compositor config & keybindings
│       │   └── scripts/
│       │       ├── theme-switch.sh# Live system theme switcher
│       │       └── toggle-opacity.sh # Live terminal opacity toggle
│       ├── mpv/                   # MPV video player bindings & config
│       ├── nvim/                  # Neovim IDE config (LSP, Blink, Conform, Lint)
│       │   ├── .luacheckrc        # Luacheck linter config
│       │   └── .stylua.toml       # StyLua formatter config
│       ├── starship.toml          # Starship shell prompt config
│       ├── stylua/                # Global StyLua formatter config
│       ├── waybar/                # Waybar bar configuration & themes
│       │   ├── config.jsonc       # Waybar module layouts
│       │   ├── launch.sh          # Atomic Waybar launcher script
│       │   └── style.css          # Waybar GTK styling
│       ├── wezterm/               # WezTerm terminal emulator config
│       │   ├── opacity.lua        # Live opacity state file
│       │   └── wezterm.lua        # WezTerm main configuration
│       ├── wlogout/               # Power & logout menu layout/styling
│       ├── wofi/                  # Application launcher styling
│       └── yazi/                  # Yazi file manager config & keymaps
```

---

## 🚀 Quick Start / Installation

### Prerequisites
Run the installer on a fresh or existing **Arch Linux** installation as your normal user (**do not run as root/sudo directly**):

```bash
git clone https://github.com/amahmod/.arch_setup.git ~/.arch_setup
cd ~/.arch_setup
chmod +x install.sh
./install.sh
```

### What `install.sh` Does:
1. **GPU Driver Setup:** Inspects `lspci` and automatically installs appropriate drivers for AMD (`vulkan-radeon`), Intel (`vulkan-intel`), or NVIDIA (`nvidia-open-dkms`).
2. **Package Installation:** Installs core Wayland packages, fonts, audio stack (`pipewire`), utilities, and build tools.
3. **AUR Helper:** Compiles `yay` from AUR if not already present.
4. **SSH & Fonts:** Decrypts SSH keys via Ansible Vault (if `.keys/id_rsa` exists) and clones private fonts into `~/.local/share/fonts`.
5. **GNU Stow:** Deploys all configuration symlinks into `$HOME`.
6. **Services:** Enables `sddm` display manager service.

---

## ⌨️ System Keybindings

### 🚀 Applications & Launchers
| Keybinding | Action |
| :--- | :--- |
| `SUPER + Return` | Open Terminal (**WezTerm**) |
| `SUPER + SPACE` | Open Application Launcher (**Wofi**) |
| `SUPER + I` | Open Emoji Picker (**wofi-emoji**) |
| `SUPER + E` | Open Terminal File Manager (**Yazi**) |
| `SUPER + SHIFT + E` | Open GUI File Manager (**Thunar**) |
| `SUPER + Q` | Close Active Window |
| `SUPER + ALT + Q` | Exit Hyprland |

### 🎨 Themes & Display
| Keybinding | Action |
| :--- | :--- |
| `SUPER + SHIFT + O` | Toggle Terminal Opacity (**Solid 100% ↔ 85% Translucent**) |
| `SUPER + SHIFT + T` | Open System Theme Switcher Menu (**Wofi**) |
| `SUPER + ALT + T` | Cycle to Next System Theme |
| `SUPER + SHIFT + B` | Reload Waybar Bar |

### 🧭 Window Navigation & Workspace Controls
| Keybinding | Action |
| :--- | :--- |
| `SUPER + H / J / K / L` | Focus Left / Down / Up / Right Window |
| `SUPER + SHIFT + H / J / K / L` | Swap Window Left / Down / Up / Right |
| `SUPER + 1 .. 9 / 0` | Switch to Workspace 1–10 |
| `SUPER + SHIFT + 1 .. 9 / 0` | Move Focused Window to Workspace 1–10 |
| `SUPER + F` | Toggle Window Fullscreen |
| `SUPER + SHIFT + F` | Toggle Window Floating Mode |
| `SUPER + Mouse Left-Click Drag` | Move Floating Window |
| `SUPER + Mouse Right-Click Drag` | Resize Window |

### 📸 Media & Utilities
| Keybinding | Action |
| :--- | :--- |
| `SUPER + S` | Capture Entire Screen to Clipboard (`grim` + `wl-copy`) |
| `SUPER + SHIFT + S` | Capture Selected Area to Clipboard (`slurp` + `grim`) |
| `XF86AudioRaiseVolume` / `SUPER + =` | Raise Audio Volume 5% |
| `XF86AudioLowerVolume` / `SUPER + -` | Lower Audio Volume 5% |
| `XF86AudioMute` | Toggle Audio Mute |

---

## 📝 Neovim Keymaps & Code Formatting

| Keymap | Action |
| :--- | :--- |
| `<leader>lf` (`Space` → `l` → `f`) | Format Active Buffer / Selection using `conform.nvim` |
| `Ctrl + S` / `<leader>w` | Save File (Triggers Auto-format on save) |
| `<leader>hd` | Open Floating Diagnostic Preview |
| `[d` / `]d` | Jump to Previous / Next Diagnostic |
| `gd` / `gD` | Go to Definition / Declaration |
| `K` | Hover Documentation |
| `<leader>rn` | Rename Symbol |
| `<leader>ca` | Code Action |

---

## ⚙️ Manual Deployment (Stow)

If you modify configurations inside `config/`, redeploy dotfiles cleanly with:

```bash
cd ~/.arch_setup
stow -R --no-folding --target="$HOME" config
```

---

## 📜 License

Personal dotfiles repository maintained by [Apel Mahmod](mailto:dev.amahmod@gmail.com). Free to use and customize for your own Arch Linux setup.
