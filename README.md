# Development Environment Setup with Ansible

This repository contains Ansible playbooks for automatically setting up a new development environment on Ubuntu/Debian systems. It installs and configures all the necessary tools, programming languages, and configurations for a complete development workspace.

## What's Included

### Programming Languages & Tools

-   **Rust** (Latest version via rustup)
-   **Go** (v1.21.6)
-   **Python3** (with pip, virtualenv, and development tools)
-   **Node.js** (Latest LTS version)

### Development Tools

-   **Build Tools**: build-essential, cmake, pkg-config, etc.
-   **Version Control**: git, lazygit
-   **Text Editor**: Neovim with custom configuration
-   **Shell**: ZSH with custom configuration
-   **Search Tools**: ripgrep, fzf
-   **SSH**: Configured with custom keys

### Fonts

-   JetBrainsMono Nerd Font
-   FiraCode Nerd Font
-   Hack Nerd Font
-   Meslo Nerd Font
-   Custom private fonts

## Prerequisites

### Required

-   **Ansible** (Required for running the playbook)
-   Ubuntu/Debian-based system
-   Python3 (Required for Ansible)
-   Basic system tools (curl, sudo)
-   Internet connection

### Installing Ansible

On Ubuntu/Debian systems, you can install Ansible in one of two ways:

1. **Using the provided script** (Recommended):

    ```bash
    ./install_ansible
    ```

2. **Manual installation**:
    ```bash
    sudo apt update
    sudo apt install -y python3-pip
    python3 -m pip install --user ansible
    ```

## Installation

1. **Clone this repository**:

    ```bash
    git clone https://github.com/amahmod/ansible.git
    cd ansible
    ```

2. **Run the playbook**:

    ```bash
    ansible-playbook local.yml --ask-vault-pass --ask-become-pass
    ```

    The flags explained:

    - `--ask-vault-pass`: Prompts for vault password to decrypt sensitive data
    - `--ask-become-pass`: Prompts for sudo password (required for system-wide installations)

    Note: Both flags are required for full installation as the playbook:

    - Contains encrypted sensitive data that needs vault password
    - Requires sudo privileges for installing system packages

## Structure

```
.
├── local.yml           # Main playbook file
├── tasks/             # Task definitions
│   ├── core.yml       # Core system packages and tools
│   ├── git.yml        # Git configuration
│   ├── node.yml       # Node.js setup
│   ├── nvim.yml       # Neovim configuration
│   ├── ssh.yml        # SSH setup
│   ├── zsh.yml        # ZSH configuration
│   └── dotfiles.yml   # Personal dotfiles setup
└── .keys/             # Directory for SSH keys
```

## Task Details

### Core Setup (`core.yml`)

-   Essential build tools and utilities
-   Programming languages (Rust, Go, Python3)
-   Development tools (lazygit, ripgrep, fzf)
-   Nerd Fonts installation

### Development Environment

-   **Neovim**: Advanced text editor setup
-   **ZSH**: Shell configuration
-   **Git**: Version control setup with lazygit
-   **SSH**: Key configuration
-   **Dotfiles**: Personal configuration files from [amahmod/.dotfiles](https://github.com/amahmod/.dotfiles)

### Dotfiles Configuration

This playbook will automatically install and configure dotfiles from [amahmod/.dotfiles](https://github.com/amahmod/.dotfiles) repository, which includes configurations for:

-   alacritty (Terminal emulator)
-   bspwm (Window manager)
-   dunst (Notification daemon)
-   kitty (Terminal emulator)
-   polybar (Status bar)
-   rofi (Application launcher)
-   tmux (Terminal multiplexer)
-   neovim (Text editor)
-   zsh (Shell)
-   And many more configurations

## Customization

To customize the installation:

1. Modify the task files in the `tasks/` directory
2. Update the variables in `local.yml`
3. Add or remove tasks from the main playbook
4. Fork the [dotfiles repository](https://github.com/amahmod/.dotfiles) and modify to your needs

## Tags

You can run specific parts of the setup using tags:

```bash
ansible-playbook local.yml --tags "install,core"
```

Available tags:

-   install
-   core
-   rust
-   go
-   python
-   node
-   fonts
-   nvim
-   zsh
-   git
-   dotfiles

## Troubleshooting

If you encounter any issues:

1. Ensure all prerequisites are installed
2. Check the Ansible output for specific error messages
3. Make sure you have proper permissions
4. Verify your internet connection

## License

This project is licensed under the MIT License - see the LICENSE file for details.
