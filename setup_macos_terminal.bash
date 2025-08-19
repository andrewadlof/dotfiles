#!/bin/bash

# Check if Homebrew is installed, if not install it
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Update Homebrew
brew update

# Install packages using Homebrew
brew install \
    bat \
    cmake \
    curl \
    fzf \
    git \
    gpg \
    htop \
    imagemagick \
    lua \
    luajit \
    neofetch \
    node \
    ripgrep \
    ruby \
    tmux \
    tree \
    vim \
    wget \
    zoxide \
    zsh

# Install casks (GUI applications and fonts)
brew install --cask \
    font-jetbrains-mono-nerd-font \
    font-hack-nerd-font

# macOS equivalent of xclip/xsel is pbcopy/pbpaste (built-in)
# No need to install separately

# Note: python3-venv equivalent - use python3 -m venv (built-in with Python 3)
# Install Python 3 if not already present
brew install python@3.11

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print messages with colors
print_message() {
    local color=$1
    local message=$2
    case $color in
        "green")  echo -e "\033[0;32m$message\033[0m" ;;
        "yellow") echo -e "\033[1;33m$message\033[0m" ;;
        "red")    echo -e "\033[0;31m$message\033[0m" ;;
        *)        echo "$message" ;;
    esac
}

# Install nvm (Node Version Manager)
if [ -d "$HOME/.nvm" ]; then
    print_message "green" "nvm is already installed"
else
    print_message "yellow" "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Load nvm immediately for the rest of the script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    
    if command_exists nvm; then
        print_message "green" "nvm installed successfully!"
        
        # Install latest LTS version of Node.js
        print_message "yellow" "Installing latest LTS version of Node.js..."
        if nvm install --lts; then
            # Set as default
            nvm alias default 'lts/*'
            print_message "green" "Node.js LTS version installed and set as default!"
        else
            print_message "red" "Failed to install Node.js LTS version"
        fi
    else
        print_message "red" "Failed to install nvm"
    fi
fi

# Install Rust first as it's required for several other tools
if command_exists rustc; then
    RUST_VERSION=$(rustc --version)
    print_message "green" "Rust is already installed: $RUST_VERSION"
else
    print_message "yellow" "Rust is not installed. Installing now..."
    
    # Check if curl is available
    if ! command_exists curl; then
        print_message "red" "Error: curl is not installed. Please install curl first."
        exit 1
    fi
    
    # Download and run the Rust installation script
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        print_message "green" "Rust has been successfully installed!"
        
        # Source the cargo environment
        source "$HOME/.cargo/env"
        
        # Verify installation
        if command_exists rustc; then
            NEW_RUST_VERSION=$(rustc --version)
            print_message "green" "Installed Rust version: $NEW_RUST_VERSION"
        else
            print_message "red" "Warning: Rust was installed but rustc command is not available."
            print_message "yellow" "Please restart your terminal or run: source $HOME/.cargo/env"
            exit 1
        fi
    else
        print_message "red" "Error: Failed to install Rust."
        exit 1
    fi
fi

# Ensure cargo is available
if ! command_exists cargo; then
    print_message "red" "Error: cargo is not available. Please restart your terminal or run: source $HOME/.cargo/env"
    exit 1
fi

# Install Zellij (requires Rust)
if command_exists zellij; then
    ZELLIJ_VERSION=$(zellij --version)
    print_message "green" "Zellij is already installed: $ZELLIJ_VERSION"
else
    print_message "yellow" "Installing Zellij..."
    if cargo install zellij; then
        print_message "green" "Zellij installed successfully!"
    else
        print_message "red" "Failed to install Zellij"
    fi
fi

# Install eza (requires Rust)
if command_exists eza; then
    EZA_VERSION=$(eza --version)
    print_message "green" "eza is already installed: $EZA_VERSION"
else
    print_message "yellow" "Installing eza..."
    if cargo install eza; then
        print_message "green" "eza installed successfully!"
    else
        print_message "red" "Failed to install eza"
    fi
fi

# Install zoxide (already installed via brew, but check if cargo version is preferred)
if command_exists zoxide; then
    ZOXIDE_VERSION=$(zoxide --version)
    print_message "green" "zoxide is already installed: $ZOXIDE_VERSION"
else
    print_message "yellow" "Installing zoxide..."
    if cargo install zoxide; then
        print_message "green" "zoxide installed successfully!"
    else
        print_message "red" "Failed to install zoxide"
    fi
fi

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_message "green" "Oh My Zsh is already installed"
else
    print_message "yellow" "Installing Oh My Zsh..."
    if curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        print_message "green" "Oh My Zsh installed successfully!"
    else
        print_message "red" "Failed to install Oh My Zsh"
    fi
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Function to install zsh plugin
install_zsh_plugin() {
    local plugin_name=$1
    local repo_url=$2
    local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

    if [ -d "$plugin_dir" ]; then
        print_message "green" "$plugin_name is already installed"
    else
        print_message "yellow" "Installing $plugin_name..."
        if git clone "$repo_url" "$plugin_dir"; then
            print_message "green" "$plugin_name installed successfully!"
        else
            print_message "red" "Failed to install $plugin_name"
        fi
    fi
}

# Install all zsh plugins
install_zsh_plugin "fzf-tab" "https://github.com/Aloxaf/fzf-tab"
install_zsh_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"
install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-expand" "https://github.com/MenkeTechnologies/zsh-expand"

# Install Oh My Posh (fonts already installed via Homebrew)
if command_exists oh-my-posh; then
    print_message "green" "Oh My Posh is already installed"
else
    print_message "yellow" "Installing Oh My Posh..."
    
    # Install Oh My Posh via Homebrew (easier on macOS)
    if brew install jandedobbeleer/oh-my-posh/oh-my-posh; then
        print_message "green" "Oh My Posh installed successfully!"
        
        # Add Oh My Posh initialization to .zshrc if not already present
        if ! grep -q "eval \"\$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')\"" "$HOME/.zshrc"; then
            echo 'eval "$(oh-my-posh init zsh --config '"'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json'"')"' >> "$HOME/.zshrc"
            print_message "green" "Added Oh My Posh initialization with JanDeDobbeleer theme to .zshrc"
        fi
    else
        print_message "red" "Failed to install Oh My Posh via Homebrew, trying manual install..."
        curl -s https://ohmyposh.dev/install.sh | bash -s
        
        # Add Oh My Posh initialization to .zshrc if not already present
        if ! grep -q "eval \"\$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')\"" "$HOME/.zshrc"; then
            echo 'eval "$(oh-my-posh init zsh --config '"'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json'"')"' >> "$HOME/.zshrc"
            print_message "green" "Added Oh My Posh initialization with JanDeDobbeleer theme to .zshrc"
        fi
    fi
fi

# Install neovim via Homebrew (much easier than adding PPAs)
if command_exists nvim; then
    print_message "green" "Neovim is already installed"
else
    print_message "yellow" "Installing Neovim..."
    if brew install neovim; then
        print_message "green" "Neovim installed successfully!"
    else
        print_message "red" "Failed to install Neovim"
    fi
fi

# Install colorls via Ruby gems (ensure Ruby is available first)
if command_exists colorls; then
    print_message "green" "colorls is already installed"
else
    print_message "yellow" "Installing colorls..."
    if gem install colorls; then
        print_message "green" "colorls installed successfully!"
    else
        print_message "red" "Failed to install colorls. You might need to run: sudo gem install colorls"
    fi
fi

# Check if requirements.txt exists before pip install
if [ -f ~/user-default-efs/requirements.txt ]; then
    pip3 install -r ~/user-default-efs/requirements.txt
else
    print_message "yellow" "Warning: requirements.txt not found in ~/user-default-efs/"
fi

# Change default shell to zsh (if not already zsh)
if [ "$SHELL" != "$(which zsh)" ]; then
    print_message "yellow" "Changing default shell to zsh..."
    chsh -s $(which zsh)
    print_message "yellow" "Default shell changed to zsh. Please restart your terminal for changes to take effect."
fi

print_message "green" "Setup complete! Please restart your terminal to enjoy your new setup."

# Note: Removed exec zsh to prevent script from hanging in non-interactive environments
# Users can manually start zsh or restart their terminal
