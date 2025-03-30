#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if dotfiles directory exists
if [ -d "$HOME/dotfiles" ]; then
    echo "Dotfiles repository exists, updating..."
    cd "$HOME/dotfiles"
    git reset --hard HEAD
    git checkout main
    git pull origin main
    echo -e "${GREEN}Dotfiles repository updated!${NC}"
else
    echo "Cloning dotfiles repository..."
    git clone https://github.com/reezpatel/dotfiles.git "$HOME/dotfiles"
    cd "$HOME/dotfiles"
    git checkout main
    echo -e "${GREEN}Dotfiles repository cloned!${NC}"
fi

echo "Checking if Homebrew is installed..."

# Check if Homebrew is installed
if command -v brew &>/dev/null; then
    echo -e "${GREEN}Homebrew is already installed!${NC}"
    echo "Current version: $(brew --version | head -n 1)"

    # Update Homebrew
    echo "Updating Homebrew..."
    brew update
    echo -e "${GREEN}Homebrew has been updated!${NC}"
else
    echo -e "${YELLOW}Homebrew is not installed. Installing now...${NC}"

    # Check OS type
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS installation
        echo "Installing Homebrew for macOS..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to path based on shell and architecture
        if [[ $(uname -m) == "arm64" ]]; then
            echo "Detected Apple Silicon Mac"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        echo "Installing Homebrew for Linux..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to path for Linux
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo -e "${RED}Unsupported operating system. Homebrew can only be installed on macOS or Linux.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Homebrew has been successfully installed!${NC}"
fi

# Install and configure nvm (Node Version Manager)
echo "Checking if nvm is installed..."

if [ -d "$HOME/.nvm" ]; then
    echo -e "${GREEN}nvm is already installed!${NC}"
else
    echo -e "${YELLOW}Installing nvm...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    echo -e "${GREEN}nvm has been successfully installed!${NC}"
fi

# Install latest LTS version of Node.js
echo "Installing latest LTS version of Node.js..."
nvm install --lts
nvm use --lts

echo -e "${GREEN}Node.js LTS has been installed and is now active!${NC}"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

# Install and configure Zsh
echo "Checking if Zsh is installed..."

if command -v zsh >/dev/null 2>&1; then
    echo -e "${GREEN}Zsh is already installed!${NC}"
else
    echo -e "${YELLOW}Installing Zsh...${NC}"
    brew install zsh
    echo -e "${GREEN}Zsh has been successfully installed!${NC}"
fi

# Install Antigen
echo "Checking if Antigen is installed..."
if [ -f "$HOMEBREW_PREFIX/share/antigen/antigen.zsh" ]; then
    echo -e "${GREEN}Antigen is already installed!${NC}"
else
    echo -e "${YELLOW}Installing Antigen...${NC}"
    brew install antigen
    echo -e "${GREEN}Antigen has been successfully installed!${NC}"
fi

# Set Zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting Zsh as default shell..."
    ZSH_PATH="$HOMEBREW_PREFIX/bin/zsh"
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
    echo -e "${GREEN}Zsh is now your default shell!${NC}"
else
    echo -e "${GREEN}Zsh is already your default shell!${NC}"
fi

# source ~/dotfiles/config/.zshrc to ~/.zshrc if not already there
if ! grep -q "source ~/dotfiles/config/.zshrc" ~/.zshrc; then
    echo "Sourcing ~/dotfiles/config/.zshrc..."
    echo "source ~/dotfiles/config/.zshrc" >>~/.zshrc
fi

# Configure git using include
if ! grep -q "include.*~/dotfiles/config/.gitconfig" ~/.gitconfig; then
    echo "Configuring git..."
    echo -e "[include]\n    path = ~/dotfiles/config/.gitconfig" >>~/.gitconfig
    echo -e "${GREEN}Git configuration has been updated!${NC}"
else
    echo -e "${GREEN}Git configuration already includes dotfiles!${NC}"
fi

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - install everything including Mac App Store apps and casks
    brew bundle --file=~/dotfiles/Brewfile
    echo -e "${GREEN}All packages have been installed!${NC}"
else
    # Linux - skip Mac App Store apps and casks
    grep -v '^mas\|^cask\|^vscode' ~/dotfiles/Brewfile | brew bundle --file=-
    echo -e "${GREEN}All supported packages have been installed!${NC}"
fi

# Configure tmux
if ! grep -q "source-file ~/dotfiles/config/tmux/tmux.conf" ~/.tmux.conf; then
    echo "Configuring tmux..."
    echo "source-file ~/dotfiles/config/tmux/tmux.conf" >>~/.tmux.conf
    echo -e "${GREEN}Tmux configuration has been updated!${NC}"
else
    echo -e "${GREEN}Tmux configuration already includes dotfiles!${NC}"
fi

# Configure neovim
if ! grep -q "source ~/dotfiles/config/nvim/init.lua" ~/.config/nvim/init.lua 2>/dev/null; then
    echo "Configuring neovim..."
    mkdir -p ~/.config/nvim
    echo "require('~/dotfiles/config/nvim/init')" >~/.config/nvim/init.lua
    echo -e "${GREEN}Neovim configuration has been updated!${NC}"
else
    echo -e "${GREEN}Neovim configuration already includes dotfiles!${NC}"
fi
