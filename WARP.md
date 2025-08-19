# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview
This repository contains personal dotfiles for setting up a modern terminal environment on Debian-based Linux systems and macOS. It provides automated setup scripts and configuration files for a development-focused shell environment.

## Key Commands

### Setup and Installation
- `./setup_debian_terminal.bash` - Complete setup script for Debian/Ubuntu systems
- `./setup_macos_terminal.bash` - Complete setup script for macOS systems
- `source ~/.zshrc` (alias: `zshsrc`) - Reload shell configuration after changes

### Development Dependencies
- Python packages are managed via the `requirements.txt` file
- Rust tools are installed via Cargo (eza, zellij, zoxide)
- Node.js packages managed via nvm

### Testing Configuration Changes
- `zshsrc` - Reload zsh configuration
- `nvim ~/.zshrc` - Edit shell configuration
- `nvim ~/.config/nvim/init.lua` - Edit Neovim configuration

## Repository Architecture

### Core Structure
```
.
├── setup_debian_terminal.bash    # Debian/Ubuntu automated setup
├── setup_macos_terminal.bash     # macOS automated setup
├── .zshrc                        # Main zsh configuration
├── requirements.txt              # Python development packages
└── .config/                      # Application configurations
    ├── nvim/                     # Neovim configuration
    ├── zellij/                   # Terminal multiplexer config
    ├── eza/                      # Modern ls replacement config
    ├── lazygit/                  # Git TUI configuration
    └── thefuck/                  # Command correction tool config
```

### Shell Configuration Architecture
The zsh configuration is structured with:
- **Exports**: Environment variables and PATH modifications
- **Oh My Zsh**: Plugin management and theme configuration
- **Aliases**: Enhanced command shortcuts and safety aliases
- **Tool integrations**: oh-my-posh, fzf, zoxide, nvm initialization

### Neovim Architecture
Neovim configuration follows a modular Lua structure:
- `init.lua` - Entry point requiring core and lazy plugin manager
- `lua/drew/core/` - Core options and keymaps
- `lua/drew/lazy.lua` - Lazy.nvim plugin manager setup
- `lua/drew/plugins/` - Individual plugin configurations
- Uses lazy.nvim for plugin management with automatic loading

### Terminal Tools Ecosystem
The setup integrates modern terminal tools:
- **Shell**: zsh with Oh My Zsh and plugins (autosuggestions, syntax highlighting, fzf-tab)
- **Prompt**: oh-my-posh with jandedobbeleer theme
- **File listing**: eza with custom Catppuccin colors
- **Fuzzy finding**: fzf with bat preview
- **Navigation**: zoxide for smart directory jumping
- **Multiplexing**: zellij with custom vim-like keybindings
- **Git**: lazygit TUI with custom configuration
- **Editor**: Neovim with comprehensive plugin setup

## Key Configuration Details

### ZSH Plugins
Active plugins include:
- `fzf-tab` - Enhanced tab completion with fzf
- `zsh-autosuggestions` - Command suggestions based on history
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `zsh-completions` - Additional completion definitions
- `zsh-expand` - Command expansion utilities

### Development Tools
- **Python**: Managed with system Python 3.12, comprehensive data science stack
- **Node.js**: Managed via nvm with LTS version
- **Rust**: Cargo-managed tools (eza, zellij, zoxide)
- **Ruby**: For colorls gem

### Color Theme
Consistent Catppuccin color scheme across:
- Terminal (oh-my-posh theme)
- File listings (eza colors)
- Neovim (via colorscheme plugin)

## Important Notes

### Cross-Platform Support
- Separate setup scripts for Debian/Ubuntu and macOS
- Platform-specific package managers (apt vs brew)
- Different font installation methods per platform

### Safety Features
- Interactive prompts for destructive operations (rm, cp, mv)
- Command correction via thefuck (aliased as `fix`)
- Git configuration prompts during setup

### Performance Optimizations
- History optimization with deduplication
- Lazy loading for heavy tools
- Efficient plugin loading with lazy.nvim
