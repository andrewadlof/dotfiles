# Dotfiles Ansible Playbook

This Ansible playbook automates the setup of your macOS terminal environment by installing all your current Homebrew formulae and casks, running the setup script, and configuring your dotfiles.

## Prerequisites

1. **Ansible**: Make sure Ansible is installed on your system
   ```bash
   # If not already installed via Homebrew
   brew install ansible
   ```

2. **Python packages**: Some Ansible modules may require additional Python packages
   ```bash
   pip3 install psutil
   ```

## What the Playbook Does

The playbook performs the following tasks in order:

1. **Homebrew Setup**:
   - Installs Homebrew if not present
   - Updates Homebrew
   - Installs all your current formulae and casks

2. **Development Tools**:
   - Installs nvm and latest LTS Node.js
   - Installs Rust and Cargo-based tools (eza, zellij, zoxide)
   - Installs Oh My Zsh and custom plugins
   - Installs colorls Ruby gem
   - Installs all Python packages from requirements.txt

3. **Configuration**:
   - Runs the `setup_macos_terminal.bash` script
   - Copies `.zshrc` to `~/.zshrc` (backs up existing file)
   - Copies entire `.config/` directory to `~/.config/`
   - Changes default shell to zsh

## Usage

### Option 1: Run the playbook directly
```bash
ansible-playbook setup-dotfiles.yml
```

### Option 2: Use the inventory file
```bash
ansible-playbook -i inventory.ini setup-dotfiles.yml
```

### Option 3: Run specific tasks only
```bash
# Install only Homebrew packages
ansible-playbook setup-dotfiles.yml --tags "homebrew"

# Configure dotfiles only
ansible-playbook setup-dotfiles.yml --tags "config"
```

## Installed Packages

### Homebrew Formulae ({{ homebrew_formulae | length }} packages)
The playbook installs all your current Homebrew formulae including:
- Development tools: `git`, `node`, `python@3.11`, `rust`, `go@1.24`
- Terminal tools: `bat`, `eza`, `fzf`, `ripgrep`, `tree`, `zoxide`
- System tools: `htop`, `tmux`, `curl`, `wget`
- Media tools: `ffmpeg`, `imagemagick`
- And many more...

### Homebrew Casks ({{ homebrew_casks | length }} casks)
Including development applications and fonts:
- `visual-studio-code`, `cursor`, `warp`
- `font-jetbrains-mono-nerd-font`, `font-hack-nerd-font`
- And others...

### Python Packages
All packages from your `requirements.txt` including data science, development, and productivity tools.

## Configuration Files

The playbook copies your entire `.config/` directory structure including:
- **Neovim**: Complete Lua configuration with plugins
- **Zellij**: Terminal multiplexer configuration
- **eza**: Modern `ls` replacement with Catppuccin colors
- **lazygit**: Git TUI configuration
- **thefuck**: Command correction tool settings
- And other application configurations

## Safety Features

- **Backup**: Existing `.zshrc` is backed up before replacement
- **Non-destructive**: Configuration files are copied without deleting existing files
- **Idempotent**: Safe to run multiple times
- **Error handling**: Tasks continue even if some fail

## Troubleshooting

### Permission Issues
If you encounter permission issues with gem installation:
```bash
# Run with elevated privileges for gem installation
ansible-playbook setup-dotfiles.yml --ask-become-pass
```

### Homebrew Path Issues
If Homebrew commands aren't found after installation:
```bash
# Source the environment manually
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

### Shell Change Issues
If the shell doesn't change automatically:
```bash
sudo chsh -s $(which zsh) $USER
```

## Post-Installation

After the playbook completes:

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Verify installation**:
   ```bash
   # Check tools are working
   oh-my-posh --version
   eza --version
   zoxide --version
   nvim --version
   ```

3. **Optional**: Customize further by editing `~/.zshrc` or configuration files in `~/.config/`

## Notes

- The playbook is designed for macOS systems
- Some installations may take time (especially Rust tools and Python packages)
- Network connection required for downloading packages and dependencies
- The setup script creates a marker file (`~/.setup_completed`) to prevent re-running

## Customization

To customize the playbook:

1. **Edit package lists**: Modify the `vars` section to add/remove packages
2. **Skip tasks**: Use `--skip-tags` to avoid certain task groups
3. **Dry run**: Use `--check` to see what would be changed without making changes

```bash
# Dry run
ansible-playbook setup-dotfiles.yml --check

# Skip Python package installation
ansible-playbook setup-dotfiles.yml --skip-tags "python"
```
