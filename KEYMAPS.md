# ⌨️ System & Application Keybindings Cheatsheet

> Complete keyboard shortcuts and quick-reference guide for all desktop environments and developer tools.
> **Total Documented Keybindings:** `317`

---

## 🧭 Table of Contents

- [ **Hyprland**](#hyprland) (`68` shortcuts)
- [ **WezTerm**](#wezterm) (`35` shortcuts)
- [ **Neovim**](#neovim) (`115` shortcuts)
- [󰇥 **Yazi**](#yazi) (`27` shortcuts)
- [󰉋 **Thunar**](#thunar) (`16` shortcuts)
- [ **IMV**](#imv) (`25` shortcuts)
- [ **Zathura**](#zathura) (`19` shortcuts)
- [󰄛 **Kitty**](#kitty) (`12` shortcuts)

---

##  Hyprland

### System

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + r` | **Reboot** | Reboot |
| `SUPER + SHIFT + d` | **Shutdown** | Shutdown |

### Volume

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + equal` | **Volume up** | Volume up |
| `XF86AudioRaiseVolume` | **Raise audio volume 5%** | Raise audio volume 5% |
| `SUPER + minus` | **Volume down** | Volume down |
| `XF86AudioLowerVolume` | **Lower audio volume 5%** | Lower audio volume 5% |
| `SUPER + m` | **Mute** | Mute |
| `XF86AudioMute` | **Toggle audio mute** | Toggle audio mute |
| `XF86AudioMicMute` | **Microphone mute** | Microphone mute |

### Screenshots

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + s` | **Screenshot** | Screenshot |
| `SUPER + SHIFT + s` | **Screenshot area/script** | Screenshot area/script |

### Launcher

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + space` | **Wofi** | Wofi |
| `SUPER + Return` | **Terminal** | Terminal |
| `SUPER + i` | **Emoji Picker** | Emoji Picker |
| `SUPER + slash` | **Keybindings Cheatsheet** | Keybindings Cheatsheet |

### Submap: Apps

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + o, C` | **Launch Google Chrome** | Launch Google Chrome |
| `SUPER + o, B` | **Launch Brave Browser** | Launch Brave Browser |
| `SUPER + o, F` | **Launch Firefox** | Launch Firefox |
| `SUPER + o, T` | **Launch Thunar File Manager** | Launch Thunar File Manager |
| `SUPER + o, L` | **Launch LocalSend (AirDrop alternative)** | Launch LocalSend (AirDrop alternative) |

### Submap: Terminal_Apps

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + t, L` | **Launch Yazi (Terminal File Manager)** | Launch Yazi (Terminal File Manager) |
| `SUPER + t, H` | **Launch Htop (System Monitor)** | Launch Htop (System Monitor) |
| `SUPER + t, N` | **Launch Neovim IDE** | Launch Neovim IDE |
| `SUPER + t, P` | **Launch Phone Transfer Suite** | Launch Phone Transfer Suite |

### Window

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + q` | **Close window** | Close window |
| `SUPER + f` | **Fullscreen** | Fullscreen |
| `SUPER + SHIFT + f` | **Toggle floating** | Toggle floating |
| `SUPER + ALT + q` | **Quit Hyprland** | Quit Hyprland |

### Focus

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + h` | **Focus window left** | Focus window left |
| `SUPER + j` | **Focus window down** | Focus window down |
| `SUPER + k` | **Focus window up** | Focus window up |
| `SUPER + l` | **Focus window right** | Focus window right |
| `SUPER + left` | **Focus window left (arrow key)** | Focus window left (arrow key) |
| `SUPER + down` | **Focus window down (arrow key)** | Focus window down (arrow key) |
| `SUPER + up` | **Focus window up (arrow key)** | Focus window up (arrow key) |
| `SUPER + right` | **Focus window right (arrow key)** | Focus window right (arrow key) |
| `SUPER + Tab` | **Focus last active window** | Focus last active window |
| `SUPER + comma` | **Focus previous monitor** | Focus previous monitor |
| `SUPER + period` | **Focus next monitor** | Focus next monitor |

### Swap / Move

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + h` | **Swap with window left** | Swap with window left |
| `SUPER + SHIFT + j` | **Swap with window down** | Swap with window down |
| `SUPER + SHIFT + k` | **Swap with window up** | Swap with window up |
| `SUPER + SHIFT + l` | **Swap with window right** | Swap with window right |
| `SUPER + SHIFT + left` | **Swap with window left (arrow key)** | Swap with window left (arrow key) |
| `SUPER + SHIFT + down` | **Swap with window down (arrow key)** | Swap with window down (arrow key) |
| `SUPER + SHIFT + up` | **Swap with window up (arrow key)** | Swap with window up (arrow key) |
| `SUPER + SHIFT + right` | **Swap with window right (arrow key)** | Swap with window right (arrow key) |

### Workspaces

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + bracketright` | **Next workspace on current monitor** | Next workspace on current monitor |
| `SUPER + bracketleft` | **Previous workspace on current monitor** | Previous workspace on current monitor |
| `SUPER + 1 .. 9 / 0` | **Switch Workspace 1–10** | Switch focus to workspace 1 through 10 |
| `SUPER + SHIFT + 1 .. 9 / 0` | **Move Window to Workspace 1–10** | Send focused window to workspace 1 through 10 |

### Window Move

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + comma` | **Move window to previous/left monitor** | Move window to previous/left monitor |
| `SUPER + SHIFT + period` | **Move window to next/right monitor** | Move window to next/right monitor |
| `SUPER + CTRL + h` | **Move floating window left** | Move floating window left |
| `SUPER + CTRL + l` | **Move floating window right** | Move floating window right |
| `SUPER + CTRL + k` | **Move floating window up** | Move floating window up |
| `SUPER + CTRL + j` | **Move floating window down** | Move floating window down |

### Window Resize

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + ALT + h` | **Resize window left** | Resize window left |
| `SUPER + ALT + l` | **Resize window right** | Resize window right |
| `SUPER + ALT + k` | **Resize window up** | Resize window up |
| `SUPER + ALT + j` | **Resize window down** | Resize window down |

### Mouse

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + mouse:272` | **Move/drag floating window with mouse** | Move/drag floating window with mouse |
| `SUPER + mouse:273` | **Resize floating window with mouse** | Resize floating window with mouse |

### Waybar

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + b` | **Reload Waybar status bar** | Reload Waybar status bar |
| `SUPER + SHIFT + g` | **Toggle Waybar module background style** | Toggle Waybar module background style |

### Theme

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + t` | **Open theme switcher menu** | Open theme switcher menu |
| `SUPER + ALT + t` | **Cycle to next theme** | Cycle to next theme |

### Opacity

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `SUPER + SHIFT + o` | **Toggle active window opacity (100% / 85%)** | Toggle active window opacity (100% / 85%) |

---

##  WezTerm

### Copy/Paste

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + Enter` | **Activate terminal copy mode** | Activate terminal copy mode |
| `ALT + c` | **Copy selection to clipboard** | Copy selection to clipboard |
| `ALT + v` | **Paste from clipboard** | Paste from clipboard |

### Scroll

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + u` | **Scroll half page up** | Scroll half page up |
| `ALT + d` | **Scroll half page down** | Scroll half page down |
| `ALT + g` | **Scroll to top of scrollback** | Scroll to top of scrollback |
| `ALT + SHIFT + G` | **Scroll to bottom of scrollback** | Scroll to bottom of scrollback |

### Pane Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + h` | **Focus pane to the left** | Focus pane to the left |
| `ALT + j` | **Focus pane below** | Focus pane below |
| `ALT + k` | **Focus pane above** | Focus pane above |
| `ALT + l` | **Focus pane to the right** | Focus pane to the right |

### Pane Resize

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + SHIFT + H` | **Resize pane left** | Resize pane left |
| `ALT + SHIFT + J` | **Resize pane down** | Resize pane down |
| `ALT + SHIFT + K` | **Resize pane up** | Resize pane up |
| `ALT + SHIFT + L` | **Resize pane right** | Resize pane right |

### Close

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + q` | **Close active pane** | Close active pane |
| `ALT + SHIFT + Q` | **Close active tab** | Close active tab |

### Tabs

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + n` | **Create new tab** | Create new tab |
| `ALT + .` | **Switch to next tab** | Switch to next tab |
| `ALT + ,` | **Switch to previous tab** | Switch to previous tab |
| `ALT + 1` | **Switch to tab 1** | Switch to tab 1 |
| `ALT + 2` | **Switch to tab 2** | Switch to tab 2 |
| `ALT + 3` | **Switch to tab 3** | Switch to tab 3 |
| `ALT + 4` | **Switch to tab 4** | Switch to tab 4 |
| `ALT + 5` | **Switch to tab 5** | Switch to tab 5 |
| `ALT + 6` | **Switch to tab 6** | Switch to tab 6 |
| `ALT + 7` | **Switch to tab 7** | Switch to tab 7 |
| `ALT + 8` | **Switch to tab 8** | Switch to tab 8 |
| `ALT + 9` | **Switch to tab 9** | Switch to tab 9 |

### Font Size

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + =` | **Increase font size** | Increase font size |
| `ALT + +` | **Increase font size** | Increase font size |
| `ALT + -` | **Decrease font size** | Decrease font size |
| `ALT + 0` | **Reset font size to default** | Reset font size to default |
| `ALT + Numpad0` | **Reset font size to default** | Reset font size to default |

### Search

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `ALT + Space` | **Show WezTerm launcher menu** | Show WezTerm launcher menu |

---

##  Neovim

### File Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>w` | **Save** | Save |
| `<leader>q` | **Quit** | Quit |
| `<C-s>` | **Save** | Save |

### Buffer Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>x` | **Delete buffer** | Delete buffer |
| `<leader>ba` | **Delete all buffers** | Delete all buffers |
| `<leader>bo` | **Delete other buffers** | Delete other buffers |
| `<S-l>` | **Go to next buffer** | Go to next buffer |
| `<S-h>` | **Go to previous buffer** | Go to previous buffer |

### Core Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<C-h>` | **Focus left split** | Focus left split |
| `<C-j>` | **Focus down split** | Focus down split |
| `<C-k>` | **Focus up split** | Focus up split |
| `<C-l>` | **Focus right split** | Focus right split |
| `<A-h>` | **Previous buffer** | Previous buffer |
| `<A-l>` | **Next buffer** | Next buffer |
| `j` | **Move down by visual line** | Move down by visual line |
| `k` | **Move up by visual line** | Move up by visual line |
| `<C-d>` | **Scroll down and center** | Scroll down and center |
| `<C-u>` | **Scroll up and center** | Scroll up and center |
| `*` | **Search word under cursor and center** | Search word under cursor and center |
| `#` | **Search word under cursor backwards and center** | Search word under cursor backwards and center |
| `n` | **Next search result** | Next search result |
| `N` | **Prev search result** | Prev search result |

### Editing Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<` | **Indent left and reselect** | Indent left and reselect |
| `>` | **Indent right and reselect** | Indent right and reselect |
| `<Tab>` | **Indent right** | Indent right |
| `<S-Tab>` | **Indent left** | Indent left |
| `J` | **Join lines and keep cursor** | Join lines and keep cursor |
| `,` | **Break undo at comma** | Break undo at comma |
| `.` | **Break undo at period** | Break undo at period |
| `;` | **Break undo at semicolon** | Break undo at semicolon |
| `U` | **Redo** | Redo |

### Clipboard Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>y` | **Copy to system clipboard** | Copy to system clipboard |
| `<leader>Y` | **Copy line to system clipboard** | Copy line to system clipboard |
| `<leader>p` | **Paste from system clipboard** | Paste from system clipboard |
| `<leader>P` | **Paste from system clipboard before** | Paste from system clipboard before |

### Keep Cursor At Bottom Of Visual Selection

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `y` | **Yank and keep cursor position** | Yank and keep cursor position |
| `p` | **Paste over selection without copying** | Paste over selection without copying |

### Path Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>yp` | **Copy relative path** | Copy relative path |
| `<leader>yP` | **Copy absolute path** | Copy absolute path |

### Toggle Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>tb` | **Toggle background** | Toggle background |
| `<leader>tw` | **Toggle word wrap** | Toggle word wrap |
| `<leader>ts` | **Toggle spell check** | Toggle spell check |
| `<leader>ti` | **Toggle invisible characters** | Toggle invisible characters |
| `<leader>tc` | **Toggle cursor line** | Toggle cursor line |

### Diagnostics (Neovim 0.12 Api)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>td` | **Toggle diagnostics** | Toggle diagnostics |

### Editing & Comments

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>cb` | **Comment box** | Comment box |

### Git (Fugitive)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>gg` | **Vim Fugitive** | Vim Fugitive |

### Fzf-Lua (Fuzzy Search)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<C-p>` | **Find files** | Find files |
| `<leader>ff` | **Find files** | Find files |
| `<leader>fo` | **Recent files** | Recent files |
| `<leader>fd` | **Find dotfiles** | Find dotfiles |
| `<leader>fs` | **Find files in cwd** | Find files in cwd |
| `<leader>fz` | **Resume last search** | Resume last search |
| `<leader>sf` | **Live grep** | Live grep |
| `<leader>sb` | **Find buffers** | Find buffers |
| `<leader>st` | **Find tabs** | Find tabs |
| `<leader>sw` | **Grep current word** | Grep current word |
| `<leader>sl` | **Search in current buffer** | Search in current buffer |
| `<leader>gf` | **Git files** | Git files |
| `<leader>gb` | **Git branches** | Git branches |
| `<leader>gc` | **Git commits** | Git commits |
| `<leader>gs` | **Git status** | Git status |
| `<leader>gl` | **Git stash** | Git stash |
| `<leader>vm` | **Find marks** | Find marks |
| `<leader>vr` | **Find registers** | Find registers |
| `<leader>vk` | **Find keymaps** | Find keymaps |
| `<leader>vc` | **Find commands** | Find commands |
| `<leader>/` | **Search history** | Search history |
| `<leader>:` | **Command history** | Command history |
| `<leader>dd` | **Document diagnostics** | Document diagnostics |
| `<leader>dw` | **Workspace diagnostics** | Workspace diagnostics |
| `<leader>dl` | **Location list** | Location list |
| `<leader>dq` | **Quickfix list** | Quickfix list |
| `<leader>hh` | **Find help tags** | Find help tags |
| `<leader>hs` | **Spell suggestions** | Spell suggestions |
| `<leader>ht` | **Find colorschemes** | Find colorschemes |
| `<leader>hm` | **Find man pages** | Find man pages |
| `<leader>ls` | **Document symbols** | Document symbols |
| `<leader>lw` | **Workspace symbols** | Workspace symbols |
| `<leader>lr` | **Find references** | Find references |
| `<leader>ld` | **Find definitions** | Find definitions |
| `<leader>li` | **Find implementations** | Find implementations |
| `<leader>lI` | **Incoming calls** | Incoming calls |

### Git (Gitsigns)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `]c` | **Next Hunk** | Next Hunk |
| `[c` | **Prev Hunk** | Prev Hunk |
| `<leader>hr` | **Reset Hunk** | Reset Hunk |
| `<leader>bs` | **Stage Buffer** | Stage Buffer |
| `<leader>hu` | **Undo Stage Hunk** | Undo Stage Hunk |
| `<leader>br` | **Reset Buffer** | Reset Buffer |
| `<leader>hp` | **Preview Hunk** | Preview Hunk |
| `<leader>bL` | **Blame Line** | Blame Line |
| `<leader>bl` | **Toggle Line Blame** | Toggle Line Blame |
| `<leader>db` | **Diff This** | Diff This |
| `<leader>dB` | **Diff This ~** | Diff This ~ |
| `ih` | **Select Hunk** | Select Hunk |

### Harpoon

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<C-S-M>` | **Harpoon Quick Menu** | Harpoon Quick Menu |

### LSP & Diagnostics

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `gd` | **LSP: Go to Definition** | LSP: Go to Definition |
| `gD` | **LSP: Go to Declaration** | LSP: Go to Declaration |
| `gT` | **LSP: Go to Type Definition** | LSP: Go to Type Definition |
| `K` | **LSP: Hover Documentation** | LSP: Hover Documentation |
| `gi` | **LSP: Go to Implementation** | LSP: Go to Implementation |
| `gr` | **LSP: References** | LSP: References |
| `<leader>hd` | **LSP: Show Line Diagnostics** | LSP: Show Line Diagnostics |
| `<leader>rn` | **LSP: Rename Symbol** | LSP: Rename Symbol |
| `<leader>ca` | **LSP: Code Action** | LSP: Code Action |
| `[d` | **LSP: Previous Diagnostic** | LSP: Previous Diagnostic |
| `]d` | **LSP: Next Diagnostic** | LSP: Next Diagnostic |
| `[e` | **LSP: Previous Error** | LSP: Previous Error |
| `]e` | **LSP: Next Error** | LSP: Next Error |
| `[w` | **LSP: Previous Warning** | LSP: Previous Warning |
| `]w` | **LSP: Next Warning** | LSP: Next Warning |
| `<leader>th` | **LSP: Toggle Inlay Hints** | LSP: Toggle Inlay Hints |

### File Explorer (Neo-tree)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>e` | **NeoTree Toggle** | NeoTree Toggle |

### Code Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `]t` | **Next todo comment** | Next todo comment |

### Undo Tree

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<leader>tu` | **Toggle Undo Tree** | Toggle Undo Tree |

---

## 󰇥 Yazi

### Custom Shortcuts

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<C-s>` | **Open shell in current directory** | Open shell in current directory |
| `<C-e>` | **Open Thunar in current directory** | Open Thunar in current directory |
| `<C-t>` | **Open Thunar in current directory** | Open Thunar in current directory |
| `g t` | **Open Thunar in current directory** | Open Thunar in current directory |
| `w` | **Set selected image as wallpaper** | Set selected image as wallpaper |

### Mobile Transfer

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `g p` | **Mount & go to Phone** | Mount & go to Phone (~/Phone) |
| `m p` | **Fast push selected file** | Fast push selected file(s) to phone (ADB) |
| `m c` | **Pull phone photos into current dir** | Pull phone photos into current dir |
| `m d` | **Pull phone downloads into current dir** | Pull phone downloads into current dir |
| `m m` | **Mount phone to ~/Phone** | Mount phone to ~/Phone |
| `m u` | **Unmount ~/Phone** | Unmount ~/Phone |
| `m s` | **Open phone transfer menu** | Open phone transfer menu |

### Core Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `h / j / k / l` | **Navigate** | Parent directory / Down / Up / Enter directory or open file |
| `Enter` | **Open File** | Open file or enter selected directory |
| `g g / G` | **Jump Top / Bottom** | Jump to top or bottom of directory |

### File Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `y` | **Yank (Copy)** | Copy selected files to internal clipboard |
| `x` | **Cut** | Cut selected files for moving |
| `p` | **Paste** | Paste yanked or cut files into current folder |
| `d` | **Move to Trash** | Soft delete selected file(s) into system trash |
| `D` | **Permanent Delete** | Permanently remove file(s) from disk |
| `a` | **Create File/Folder** | Create a new file (append / to create a folder) |
| `r` | **Rename** | Rename the currently highlighted file |

### Searching & View

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `/` | **Fuzzy Search** | Fuzzy search files within current directory |
| `z` | **Jump via Zoxide** | Fuzzy jump to recent directory using zoxide |
| `.` | **Toggle Hidden Files** | Show or hide dotfiles in file list |
| `v` | **Visual Selection** | Toggle continuous visual selection mode |
| `q` | **Quit Yazi** | Exit terminal file manager |

---

## 󰉋 Thunar

### Context Menu (Actions)

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Right-Click` | **Open Terminal Here** | Open terminal in the selected directory |
| `Right-Click` | **⚡ Send to Phone (High Speed ADB)** | Push selected files/folders to phone at maximum USB/Wi-Fi speed |
| `Right-Click` | **📸 Pull Photos from Phone (ADB)** | Pull camera photos from phone into this directory |
| `Right-Click` | **📥 Pull Downloads from Phone (ADB)** | Pull downloaded files from phone into this directory |
| `Right-Click` | **📱 Mirror Phone Screen (scrcpy)** | Mirror phone screen on Hyprland (drag and drop files to transfer) |

### Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Alt + Up` | **Parent Directory** | Open parent directory |
| `Alt + Left / Right` | **History Back / Forward** | Go back or forward in folder navigation history |
| `Ctrl + L` | **Location Bar** | Focus address / location bar for path typing |

### Tabs & Windows

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + T` | **New Tab** | Open a new tab in current window |
| `Ctrl + W` | **Close Tab** | Close active tab or window |
| `Ctrl + N` | **New Window** | Open a new file manager window |

### View

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + H` | **Toggle Hidden Files** | Show or hide dotfiles |
| `Ctrl + 1 / 2 / 3` | **View Modes** | Switch between Icon View, Detailed List, and Compact View |

### File Operations

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `F2` | **Rename** | Rename the selected file or folder |
| `Delete` | **Move to Trash** | Send selected file(s) to system trash |
| `Shift + Delete` | **Permanent Delete** | Permanently erase file without using trash |

---

##  IMV

### Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `h` | **Pan image left** | Pan image left (pan -50 0) |
| `j` | **Pan image down** | Pan image down (pan 0 50) |
| `k` | **Pan image up** | Pan image up (pan 0 -50) |
| `l` | **Pan image right** | Pan image right (pan 50 0) |
| `n` | **Next image in directory** | Next image in directory (next) |
| `p` | **Previous image in directory** | Previous image in directory (prev) |
| `gg` | **Jump to first image** | Jump to first image (goto 0) |
| `G` | **Jump to last image** | Jump to last image (goto -1) |
| `h / j / k / l` | **Pan Image** | Pan image left / down / up / right |
| `n / p` | **Next / Prev Image** | View next or previous image in directory |
| `g g / G` | **First / Last Image** | Jump to first image or last image |

### Zoom & Scaling

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `i` | **Zoom in** | Zoom in (zoom 1) |
| `o` | **Zoom out** | Zoom out (zoom -1) |
| `z` | **Scale to 100% actual size** | Scale to 100% actual size (scale actual) |
| `Z` | **Scale image to fit window** | Scale image to fit window (scale fit) |
| `+ / -` | **Zoom In / Out** | Zoom in or zoom out on image |
| `s` | **Scale to Window** | Scale image to fit current window size |
| `c` | **Center Image** | Re-center image in the viewport |

### Rotation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `r` | **Rotate 90 degrees clockwise** | Rotate 90 degrees clockwise (rotate 90) |
| `R` | **Rotate 90 degrees counter-clockwise** | Rotate 90 degrees counter-clockwise (rotate 270) |

### Display & System

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `d` | **Toggle overlay info (index, name, resolution)** | Toggle overlay info (index, name, resolution) (overlay) |
| `f` | **Toggle fullscreen mode** | Toggle fullscreen mode (fullscreen) |
| `q` | **Quit IMV** | Quit IMV (quit) |
| `<Escape>` | **Quit IMV** | Quit IMV (quit) |

### General

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `x` | **Close Image** | Close current image and proceed to next |

---

##  Zathura

### View & Display

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `i` | **Toggle dark mode / color inversion** | Toggle dark mode / color inversion (recolor) |
| `r` | **Reload document from disk** | Reload document from disk (reload) |
| `R` | **Rotate document 90 degrees clockwise** | Rotate document 90 degrees clockwise (rotate) |

### Fullscreen Mode

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `[fullscreen] a` | **[Fullscreen] Adjust zoom to fit entire page in window** | [Fullscreen] Adjust zoom to fit entire page in window (adjust_window best-fit) |
| `[fullscreen] s` | **[Fullscreen] Adjust zoom to fit page width to window** | [Fullscreen] Adjust zoom to fit page width to window (adjust_window width) |

### Navigation

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `h / j / k / l` | **Scroll** | Scroll left / down / up / right through document |
| `J / K` | **Next / Prev Page** | Jump to next or previous document page |
| `g g / G` | **First / Last Page** | Jump to first page or last page |
| `<PageDown> / <PageUp>` | **Page Scroll** | Scroll down or up by a full page |
| `f` | **Follow Link** | Highlight and follow clickable links using keyboard hints |

### View & Zoom

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `r / R` | **Rotate Document** | Rotate document 90 degrees clockwise or counter-clockwise |
| `a` | **Fit Width** | Adjust zoom to fit page width to window |
| `s` | **Fit Page** | Adjust zoom to fit entire page in window |
| `d` | **Dual Page Mode** | Toggle side-by-side two-page reading mode |
| `+ / - / =` | **Zoom In / Out / Reset** | Increase zoom, decrease zoom, or reset to 100% |

### Colors & Search

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `<Ctrl-r>` | **Invert Colors** | Toggle dark mode / color inversion for comfortable reading |
| `/` | **Search Text** | Search forward for text inside PDF document |
| `n / N` | **Next / Prev Match** | Jump to next or previous search result |

### General

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `q` | **Quit Zathura** | Close PDF viewer |

---

## 󰄛 Kitty

### Window Management

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + Shift + Enter` | **New Window (Split)** | Open a new terminal pane split |
| `Ctrl + Shift + W` | **Close Window** | Close currently active terminal pane |
| `Ctrl + Shift + ] / [` | **Next / Prev Window** | Cycle focus to next or previous split pane |
| `Ctrl + Shift + L` | **Next Layout** | Cycle layout (splits, stack, tall, grid) |

### Tab Management

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + Shift + T` | **New Tab** | Create a new terminal tab |
| `Ctrl + Shift + Q` | **Close Tab** | Close active tab |
| `Ctrl + Shift + Right / Left` | **Next / Prev Tab** | Switch to next or previous tab |

### Scrolling

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + Shift + Up / Down` | **Scroll Line** | Scroll terminal history by one line |
| `Ctrl + Shift + Page_Up / Page_Down` | **Scroll Page** | Scroll terminal history by full page |
| `Ctrl + Shift + Home / End` | **Scroll Top / Bottom** | Jump to beginning or end of terminal scrollback |

### Font & Clipboard

| Keybinding | Title | Description |
| :--- | :--- | :--- |
| `Ctrl + Shift + + / - / Backspace` | **Font Size** | Increase, decrease, or reset terminal font size |
| `Ctrl + Shift + C / V` | **Copy / Paste** | Copy selection or paste from system clipboard |

---
