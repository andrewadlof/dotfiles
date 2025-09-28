#!/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --needed --noconfirm \
    base-devel \
    bat \
    cmake \
    curl \
    fzf \
    git \
    htop \
    imagemagick \
    lua \
    luajit \
    python \
    python-pip \
    python-virtualenv \
    neofetch \
    nodejs \
    npm \
    ripgrep \
    ruby \
    tmux \
    tree \
    vim \
    wget \
    xclip \
    xsel \
    zip \
    zoxide \
    zsh

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

# Install AUR helper (paru) if not already installed
if ! command_exists paru; then
    print_message "yellow" "Installing paru (AUR helper)..."
    
    # Create temporary directory for paru installation
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Clone paru repository
    git clone https://aur.archlinux.org/paru.git
    cd paru
    
    # Build and install paru
    makepkg -si --noconfirm
    
    # Clean up
    cd "$HOME"
    rm -rf "$temp_dir"
    
    if command_exists paru; then
        print_message "green" "paru installed successfully!"
    else
        print_message "red" "Failed to install paru"
    fi
else
    print_message "green" "paru is already installed"
fi

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

# Install zoxide (already installed via pacman, but check if cargo version is preferred)
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

# Install Oh My Posh and required fonts
if command_exists oh-my-posh; then
    print_message "green" "Oh My Posh is already installed"
else
    print_message "yellow" "Installing Oh My Posh and required fonts..."
    
    # Create fonts directory if it doesn't exist
    mkdir -p ~/.local/share/fonts
    
    # Install Hack font
    print_message "yellow" "Installing Hack font..."
    wget -O hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
    unzip -o hack.zip -d ~/.local/share/fonts/hack
    rm hack.zip
    
    # Install JetBrains Mono Nerd Font
    print_message "yellow" "Installing JetBrains Mono Nerd Font..."
    wget -O jetbrains.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -o jetbrains.zip -d ~/.local/share/fonts/jetbrains
    rm jetbrains.zip
    
    # Update font cache
    fc-cache -f -v
    print_message "green" "Fonts installed successfully!"
    
    # Install Oh My Posh
    print_message "yellow" "Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s

    # Add Oh My Posh initialization to .zshrc if not already present
    if ! grep -q "eval \"\$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')\"" "$HOME/.zshrc"; then
        echo 'eval "$(oh-my-posh init zsh --config '"'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json'"')"' >> "$HOME/.zshrc"
        print_message "green" "Added Oh My Posh initialization with JanDeDobbeleer theme to .zshrc"
    fi
fi

# Install neovim (already installed via pacman)
print_message "green" "Neovim is installed via pacman"

# Install colorls via Ruby gems
if command_exists colorls; then
    print_message "green" "colorls is already installed"
else
    print_message "yellow" "Installing colorls..."
    if gem install colorls --user-install; then
        print_message "green" "colorls installed successfully!"
        
        # Add gem bin directory to PATH in .zshrc if not already present
        GEM_BIN_PATH="$(ruby -e 'puts Gem.user_dir')/bin"
        if ! grep -q "$GEM_BIN_PATH" "$HOME/.zshrc"; then
            echo "export PATH=\"\$PATH:$GEM_BIN_PATH\"" >> "$HOME/.zshrc"
            print_message "green" "Added gem bin directory to PATH in .zshrc"
        fi
    else
        print_message "red" "Failed to install colorls"
    fi
fi

# Check if requirements.txt exists before pip install
if [ -f ~/user-default-efs/requirements.txt ]; then
    pip install --user -r ~/user-default-efs/requirements.txt
else
    print_message "yellow" "Warning: requirements.txt not found in ~/user-default-efs/"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $(whoami)
    print_message "yellow" "Default shell changed to zsh. Please log out and log back in for changes to take effect."
fi

# Launch zsh
exec zsh

# Change to home directory
cd ~
