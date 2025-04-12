# Ansible Setup

This Ansible playbook is designed to automate the setup and configuration of a development environment. It includes tasks for setting up SSH, core system packages, Git, Node.js, Zsh, Neovim, window manager, and dotfiles.

## Prerequisites

-   Ansible
-   Arch Linux (or compatible system)
-   Python 3.x

## Required Collections

The playbook uses the following Ansible Galaxy collections:

-   `kewlfft.aur` - For managing AUR packages

## Installation

```bash
$ ./install
```

## Playbook Structure

The playbook is organized into several task files:

-   `tasks/ssh.yml` - SSH configuration
-   `tasks/systeme.yml` - Core system packages
-   `tasks/git.yml` - Git setup
-   `tasks/node.yml` - Node.js installation
-   `tasks/zsh.yml` - Zsh configuration
-   `tasks/nvim.yml` - Neovim setup
-   `tasks/wm.yml` - Window manager configuration
-   `tasks/dotfiles.yml` - Dotfiles management

## Variables

The playbook uses the following variables:

-   `source_key`: Path to the source SSH key
-   `dest_key`: Destination path for the SSH key
-   `username`: Current user's username

## Tags

The playbook includes the following tags:

-   `install` - For installation tasks
-   `core` - For core system configuration
-   `zsh` - For Zsh-related tasks
-   `node` - For Node.js installation and configuration
-   `neovim` - For Neovim setup
-   `wm` - For window manager configuration
-   `git` - For Git setup
-   `ssh` - For SSH configuration
-   `dotfiles` - For dotfiles management

You can run specific parts of the playbook using tags. For example:

```bash
ansible-playbook local.yml --tags "install,node" --ask-become-pass --ask-vault-pass
```
