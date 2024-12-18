#!/bin/bash

# Update system
sudo apt update && sudo apt -y upgrade

# Install packages
sudo apt install -y \
    apt-transport-https \
    bat \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    fzf \
    git \
    gpg \
    htop \
    neofetch \
    nodejs \
    ripgrep \
    ruby-full \
    software-properties-common \
    tmux \
    tree \
    vim \
    wget \
    zip \
    zsh

# create symlink to bat library
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

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

# Check if rustc is already installed
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
        fi
    else
        print_message "red" "Error: Failed to install Rust."
        exit 1
    fi
fi

# Install neovim
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update && sudo apt -y upgrade

# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Check if cargo is available
if ! command_exists cargo; then
    print_message "red" "Warning: cargo is not available. You may need to restart your terminal or run: source $HOME/.cargo/env"
fi

# Install eza
cargo install eza

# Install colorls via Ruby gems
sudo gem install colorls

# Check if requirements.txt exists before pip install
if [ -f ~/user-default-efs/requirements.txt ]; then
    pip install -r ~/user-default-efs/requirements.txt
else
    echo "Warning: requirements.txt not found in ~/user-default-efs/"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh)
    echo "Default shell changed to zsh. Please log out and log back in for changes to take effect."
fi

# Launch zsh
exec zsh