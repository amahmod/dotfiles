# AGENTS.md — AI Agent Guidelines & Repository Architecture

Welcome, agent! This document serves as the single source of truth for AI agents (like Antigravity / Cursor / Claude) working in the `~/.arch_setup` repository. Read this document before making modifications.

---

## 1. Repository Purpose

`~/.arch_setup` is the complete personal dotfiles, workstation configuration, and automated installation suite for **Arch Linux** running **Hyprland (Wayland)**, tailored for Apel Mahmod (`amahmod`).

It manages:
- **Desktop Environment:** Hyprland configured in Lua (`hyprland.lua`), Waybar, Dunst, Wofi, Wlogout.
- **Terminal & Editor:** WezTerm, Neovim (LSP, Blink, Conform, Lint), Zsh (Starship, Vi mode), Yazi.
- **Multilingual Input:** IBus Wayland integration supporting English (US), Bengali (Avro Phonetic), and Arabic 101.
- **Workflow Automation:** Universal keybinding parser & cheatsheet generator (`keymaps`), high-speed Android/iOS mobile transfer suite (`phone-transfer`), system-wide live theme switcher (`theme-switch.sh`).
- **System Provisioning:** Automated end-to-end Arch installer (`install.sh`) with GNU Stow management, hardware driver detection, and font caching.

---

## 2. Core Behavioral Rules & Taste Constraints

Always adhere strictly to these rules:

### Rule 1: NEVER Install Packages Directly in Agent Shell
- **DO NOT** execute `sudo pacman -S <pkg>` or `yay -S <pkg>` directly.
- **DO:** Add the package to the appropriate array in [`install.sh`](install.sh):
  - Official Arch packages ➔ `PACKAGES=(...)`
  - AUR packages ➔ `AUR_PACKAGES=(...)`
- Provide configuration files in `config/` and instruct the user to run `./install.sh` if new system packages are required.

### Rule 2: DO NOT Auto-Commit Changes
- **Never commit changes to git** unless the user explicitly asks (e.g., "commit changes").
- When asked to commit, follow the repository's **Conventional Commits** style (e.g. `feat(scope): ...`, `fix(scope): ...`).

### Rule 3: GNU Stow Workflow (All Configs Live in `config/`)
- **NEVER** edit files directly inside `~/.config/...` or `$HOME` unless they are verified symlinks pointing back to `config/`.
- All tracked dotfiles reside inside the [`config/`](config/) directory.
- Symlinks are managed by **GNU Stow**:
  ```bash
  (cd ~/.arch_setup && stow -R --no-folding --target="$HOME" config)
  ```
- Before stowing new directories, ensure parent directories exist in `$HOME` (e.g., `mkdir -p "$HOME/.config/environment.d"`) to prevent Stow tree-folding.

### Rule 4: Always Keep Keymaps Synchronized
- Whenever you modify keybindings in any application config (`hyprland.lua`, `wezterm.lua`, etc.), run:
  ```bash
  ~/.local/bin/keymaps sync && ~/.local/bin/keymaps report
  ```
- This refreshes the JSON registries in `config/.config/keymaps/*.json` and regenerates [`KEYMAPS.md`](KEYMAPS.md).

### Rule 5: Maintain Documentation & Code Integrity
- Preserve existing comments, docstrings, and formatting style across all files.
- Format Lua files using `stylua` and shell scripts using `shfmt`.

---

## 3. Subsystem Breakdown & Architecture

### 3.1 Hyprland Configuration (`config/.config/hypr/hyprland.lua`)
- **Language:** Written in **Lua** using Hyprland's native Lua configuration bindings (`hl.*`).
- **Reloading:** Always test changes with `hyprctl reload`.
- **Syntax Quirks to Remember:**
  - In `hl.window_rule`: Use snake_case `no_focus = true` (NOT `nofocus`).
  - Keybinding repeats: To make a binding repeat when held down, pass `{ repeating = true }` (equivalent to `binde` in standard hyprland.conf).
  - Floating/Window actions: Use `hl.dsp.window.*` dispatchers.
  - Monitors & workspaces: Uses dynamic monitors helper `setup_monitors_and_workspaces()` (Workspaces 1–5 on Primary, 6–10 on Secondary).

### 3.2 Multilingual Input & IBus Wayland Integration
- **Languages:**
  1. English (US) — `xkb:us::eng` (Hyprland layout index `0`)
  2. Bengali (Avro Phonetic) — `ibus-avro`
  3. Arabic 101 — `xkb:ara::ara` (Hyprland layout index `1`)
- **Toggling Keybindings:**
  - `SUPER + Backspace` or `SUPER + SHIFT + space` calls [`toggle-keyboard-layout.sh`](config/.config/hypr/scripts/toggle-keyboard-layout.sh).
  - Cycles: English ➔ Bengali Avro ➔ Arabic ➔ English with Dunst notifications and synchronized XKB layouts.
- **IBus Wayland Startup:**
  - Autostarted via `hyprland.lua`:
    ```lua
    hl.exec_cmd 'ibus-daemon -drx --panel=/usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im'
    ```
  - Using `--panel=/usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im` connects directly to Wayland's `zwp_input_method_v2` protocol and eliminates the "IBus should be called from desktop session in Wayland" warning.
- **Environment Variables:**
  - Set in [`.zshrc`](config/.zshrc), [`.bash_profile`](config/.bash_profile), and [`10-ibus.conf`](config/.config/environment.d/10-ibus.conf):
    ```sh
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export INPUT_METHOD=ibus
    export SDL_IM_MODULE=ibus
    export GLFW_IM_MODULE=ibus
    ```
- **Avro Phonetic Wayland Fix (`patch-ibus-avro.sh`):**
  - Upstream `sarim/ibus-avro` has a Left Shift bug (`keycode == 42` returns `true`), swallowing Shift presses on Wayland.
  - [`patch-ibus-avro.sh`](config/.config/hypr/scripts/patch-ibus-avro.sh) patches `/usr/share/ibus-avro/main-gjs.js` to pass through keycodes 42 and 54 (`return false`), prevents GTK3/GTK4 conflicts when launching preferences, and silences journal print spam.
  - Automated in `install.sh` and can be run standalone via `bash ~/.config/hypr/scripts/patch-ibus-avro.sh`.

### 3.3 Terminal & Shell
- **WezTerm (`config/.config/wezterm/`):**
  - Uses `use_ime = true` for IBus candidate window support.
  - Fallback fonts configured for Bengali (`Noto Sans Bengali`) and Arabic (`Noto Sans Arabic`, `Scheherazade New`).
  - Terminal opacity toggle (`SUPER + SHIFT + O`) toggles [`opacity.lua`](config/.config/wezterm/opacity.lua) between `1.0` and `0.85`.
- **Shells:**
  - Default shell is **Zsh** with Vi mode, Starship prompt, `fzf`, and `zoxide`.
  - `.bash_profile` ensures Hyprland is autostarted on TTY1 login.

### 3.4 Keymaps Registry (`config/.local/bin/keymaps`)
- Python-based universal keybinding scraper and cheatsheet tool.
- Scrapes: `hyprland.lua`, `wezterm.lua`, Neovim Lua files, `yazi.toml`, `thunar/uca.xml`, `imv/config`, `zathurarc`, `kitty.conf`.
- Commands:
  - `keymaps search <query>`: Interactive FZF / fuzzy search for keybindings.
  - `keymaps sync`: Scrapes configs and outputs JSON registries to `config/.config/keymaps/`.
  - `keymaps report`: Renders GitHub-flavored markdown cheatsheet to `KEYMAPS.md`.

### 3.5 Phone Transfer Suite (`phone-transfer`)
- High-speed bidirectional phone file transfer for Android (ADB) and iOS (usbmuxd).
- CLI: `phone-transfer` (or `pt`), `phone-mount` (`pm`), `phone-webserver`.
- Yazi bindings: `g p` (go to phone), `m p` (push to phone), `m c` (pull camera).
- Thunar integration: Right-click custom actions via `config/.config/Thunar/uca.xml`.

---

## 4. Useful Maintenance & Verification Commands

```bash
# Reload Hyprland configuration
hyprctl reload

# Resync keybindings documentation
~/.local/bin/keymaps sync && ~/.local/bin/keymaps report

# Restow all dotfiles to $HOME
(cd ~/.arch_setup && stow -R --no-folding --target="$HOME" config)

# Check git status
git status

# Test IBus status & engine
ibus engine
ibus list-engine
```
