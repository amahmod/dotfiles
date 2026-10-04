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
- **📱 High-Speed Phone Transfer Suite (Thunar & Yazi)**
  - Seamless two-way copy & paste between PC and mobile (Android & iOS).
  - Native **Thunar** sidebar device mounting & right-click high-speed ADB actions.
  - Dedicated **Yazi** bindings: `g p` (jump to phone filesystem), `m p` (high-speed ADB push), `m c` (pull camera).
  - Built-in `phone-transfer` CLI with ADB turbo transfers (up to 100+ MB/s), wireless ADB, screen mirroring (`scrcpy`), and zero-app QR code web sharing (`phone-transfer web`).
- **🛠️ Fully Automated Installer (`install.sh`)**
  - Automatic GPU hardware detection (AMD, Intel, NVIDIA drivers & VA-API video acceleration).
  - Package installation via `pacman` and `yay` (AUR helper).
  - Mobile device stack installation (`android-tools`, `android-udev`, `gvfs-mtp`, `localsend-bin`, `usbmuxd`).
  - Automated Ansible Vault decryption for SSH keys (`.keys/id_rsa`).
  - Private font repository cloning and GNU Stow dotfile deployment.

---

## 📦 Managed Configuration Directory

```
.arch_setup/
├── install.sh                     # Automated installation script
├── config/
│   ├── .bash_profile              # Shell launch profile
│   ├── .local/
│   │   └── bin/
│   │       ├── keymaps            # Unified keybinding search & cheatsheet CLI
│   │       ├── keymap-report      # Auto-generate cheatsheet report (KEYMAPS.md)
│   │       ├── phone-transfer     # High-speed phone transfer suite & CLI
│   │       ├── phone-mount        # Mounts phone to ~/Phone for Yazi/terminal
│   │       └── phone-webserver    # Instant QR code web transfer server
│   ├── .zshrc                     # Zsh configuration (Starship, Vi mode, zoxide)
│   └── .config/
│       ├── keymaps/               # Extracted JSON keybinding registries for all apps
│       ├── Thunar/
│       │   └── uca.xml            # Thunar custom right-click actions (ADB Push/Pull)
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
| `SUPER + /` | Open Keybindings Cheatsheet (**Wofi**) |
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

### 📱 Phone & Mobile Transfer Keybindings
| Shortcut / Keymap | Context | Action |
| :--- | :--- | :--- |
| `g p` | **Yazi** | Mount & jump to `~/Phone` (browse & copy/paste) |
| `m p` | **Yazi** | Turbo push selected file(s) to phone via ADB |
| `m c` | **Yazi** | Pull phone camera photos into current folder |
| `m d` | **Yazi** | Pull phone downloads into current folder |
| `m m` / `m u` | **Yazi** | Mount / unmount `~/Phone` |
| `m s` | **Yazi** | Launch interactive `phone-transfer` menu |
| Right-Click | **Thunar** | **⚡ Send to Phone (High Speed ADB)** |
| Right-Click | **Thunar** | **📸 Pull Photos from Phone** |
| Right-Click | **Thunar** | **📥 Pull Downloads from Phone** |
| Right-Click | **Thunar** | **📱 Mirror Phone Screen (`scrcpy`)** |
| `SUPER + O, L` | **Hyprland** | Launch **LocalSend** (cross-platform AirDrop) |
| `SUPER + T, P` | **Hyprland** | Launch **Phone Transfer CLI** in terminal |

---

## 📱 High-Speed Mobile File Transfer Guide (Thunar & Yazi)

Seamlessly transfer files between your Arch Linux machine and mobile devices (Android & iOS) at maximum hardware and network speeds:

### 1. In Thunar (GUI File Manager - `SUPER + SHIFT + E`)
- **Native Drag-and-Drop & Copy/Paste (`Ctrl+C` / `Ctrl+V`):**
  - Plug your phone via USB and select **File Transfer / MTP** on your phone.
  - Your phone immediately appears under **Devices** in the Thunar sidebar.
  - Click to browse internal storage and copy/paste files normally.
- **Right-Click Context Menu Actions (High-Speed ADB):**
  - Right-click any file/folder → **⚡ Send to Phone (High Speed ADB)**: Pushes directly to `/sdcard/Download/` at up to 100+ MB/s.
  - Right-click any directory → **📸 Pull Photos from Phone**: Downloads `/sdcard/DCIM/Camera` into that folder.
  - Right-click any directory → **📥 Pull Downloads from Phone**: Downloads `/sdcard/Download` into that folder.
  - Right-click → **📱 Mirror Phone Screen**: Launches `scrcpy` with drag-and-drop file transfer support.

### 2. In Yazi (Terminal File Manager - `SUPER + E`)
- **Direct Filesystem Copy/Paste (`y` / `p`):**
  - Press `g p` (Go to Phone): Automatically mounts your phone and jumps to `~/Phone`.
  - Press `y` to yank (copy) any file from phone or PC, navigate to target folder, and press `p` to paste.
- **Fast Action Shortcuts:**
  - `m p`: Select files in Yazi and press `m p` to push directly to `/sdcard/Download/` via ADB at wire speed.
  - `m c`: Navigate to your pictures directory and press `m c` to pull camera photos.
  - `m d`: Press `m d` to pull phone downloads into the current folder.
  - `m s`: Open the interactive transfer menu without leaving Yazi.

### 3. CLI & Wireless Transfers (`phone-transfer`)
- `phone-transfer` (or `pt`): Interactive terminal menu with device diagnostics (battery, storage, model).
- `phone-transfer push <files...>`: High-speed push to phone via ADB with automatic gallery media scan.
- `phone-transfer pull [photos|downloads|all]`: High-speed pull from phone to PC.
- `phone-transfer tcpip`: Disconnect your USB cable and continue transferring over Wi-Fi!
- `phone-transfer web`: Starts instant local web server and prints a terminal QR code. Scan with your phone camera to upload or download files in your phone's browser (no app required).
- `phone-transfer mirror`: Screen mirroring via `scrcpy`. Drag and drop any file into the phone window to transfer.
- `SUPER + O, L`: Launch **LocalSend** (cross-platform peer-to-peer AirDrop alternative).

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

## ⌨️ Universal Keybindings Cheatsheet & Report Generator

Instant search and cheatsheet generator covering **Hyprland**, **WezTerm**, **Neovim**, **Yazi**, **Thunar**, **IMV**, **Zathura**, and **Kitty**:

### 1. Interactive GUI Finder (`SUPER + /`)
- Press `SUPER + /` anywhere to pop up an interactive **Wofi** search menu.
- **Search by Key, Title, or Description**: Type `nvim` to filter Neovim keys, `format` to find code formatting, `opacity` to find terminal toggles, or `phone` to find mobile transfers.
- **Copy to Clipboard**: Selecting any entry automatically copies the shortcut to your clipboard (`wl-copy`) and sends a notification.

### 2. Terminal Interactive Finder (`keymaps --fzf`)
- Run `keymaps --fzf` in terminal for a two-pane interactive browser with live description preview.
- Run `keymaps list` or `keymaps list -a <app>` to print keymaps directly.

### 3. Automated Report Generator (`keymap-report` or `keymaps report`)
- Automatically scrapes your actual config files (`hyprland.lua`, `keybindings.lua`, `mappings.lua`, `keymap.toml`, `imv/config`, `zathurarc`, `uca.xml`) using comments (`--`, `#`) and native `desc` metadata.
- Run `keymap-report` to generate or refresh [KEYMAPS.md](file:///home/amahmod/.arch_setup/KEYMAPS.md) with comprehensive categorized tables.
- Run `keymaps sync` to update the JSON databases in `~/.config/keymaps/`.

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
