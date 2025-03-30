# Dotfiles

A collection of configuration files and setup scripts to quickly bootstrap a new development environment on macOS or Linux systems. This repository contains my personal dotfiles and automated setup scripts that handle:

- Shell configuration (Zsh + Antigen for plugin management)
- Package management via Homebrew
- Development tools and utilities
- System preferences and sensible defaults

Remember: The best dotfiles are the ones that match your personal workflow and preferences. Use these as a starting point, not a destination.

## Installation

You can install these dotfiles in two ways:

### Option 1: Clone and Run Install Script

```bash
# Clone the repository
git clone https://github.com/reezpatel/dotfiles.git
cd dotfiles

# Make the install script executable
chmod +x install.sh

# Run the install script
./install.sh
```

### Option 2: Direct Installation (without cloning)

You can install directly from GitHub without cloning the repository first:

```bash
curl -fsSL https://raw.githubusercontent.com/reezpatel/dotfiles/main/install.sh | bash
```

## What Does the Install Script Do?

The install script automates the following setup tasks:


1. **Repository Management**
   - Clones or updates the dotfiles repository
   - Ensures you have the latest version

2. **Homebrew Setup**
   - Checks if Homebrew is installed
   - Installs Homebrew if missing (handles both macOS and Linux)
   - Updates existing Homebrew installation
   - Configures proper PATH based on system architecture

3. **Node.js Environment**
   - Installs Node Version Manager (nvm)
   - Installs latest LTS version of Node.js
   - Sets up npm

4. **Shell Configuration**
   - Installs Zsh if not present
   - Installs Antigen for Zsh plugin management
   - Sets Zsh as the default shell
   - Links the dotfiles Zsh configuration

5. **Git Configuration**
   - Sets up Git configuration using include directive
   - Links to dotfiles Git configuration

6. **Package Installation**
   - Installs all packages listed in Brewfile:
     - CLI tools (git, neovim, tmux, etc.)
     - GUI applications (via Homebrew Cask)
     - Mac App Store applications (on macOS)
     - Development tools and utilities

7. **Development Tools Setup**
   - Configures tmux with custom settings
   - Sets up Neovim with plugins and configurations
   - Installs various development utilities

The script is idempotent - it can be run multiple times safely and will only install/update what's necessary.


## Post-Installation

After running the install script:

1. Restart your terminal to apply the zsh configuration
2. Start tmux with `tmux` command to use the tmux configuration
3. For Neovim, open with `nvim` and it will automatically install plugins on first run
## Updating

To update your dotfiles to the latest version:

```bash
cd ~/path/to/dotfiles
git pull
./install.sh
```

## Troubleshooting

If you encounter any issues during installation:

1. Check the console output for error messages
2. Ensure you have the necessary permissions
3. Make sure you have the required dependencies installed
4. For specific tool issues, refer to their respective documentation

## License

This project is open-sourced and available for anyone to use and modify.