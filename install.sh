#!/bin/bash

#### HELPER FUNCTIONS ####

function insert_or_update_block {
    local unique_id="$1"
    local content="$2"
    local file_path="$3"

    # Create the directory if it doesn't exist
    mkdir -p "$(dirname "$file_path")"

    # Check if the file exists
    if [[ ! -f "$file_path" ]]; then
        # Create the file with the initial block
        echo "# INSERTED_BY_DOTFILE START $unique_id" >"$file_path"
        echo "$content" >>"$file_path"
        echo "# INSERTED_BY_DOTFILE END $unique_id" >>"$file_path"
        echo "File created: $file_path"
    else
        # Replace the existing block
        sed -i '' "/# INSERTED_BY_DOTFILE START $unique_id/,/# INSERTED_BY_DOTFILE END $unique_id/d" "$file_path"

        # Use cat to append the content at the end of the file
        cat >>"$file_path" <<EOF
# INSERTED_BY_DOTFILE START $unique_id
$content
# INSERTED_BY_DOTFILE END $unique_id
EOF

        echo "Block updated in: $file_path"
    fi
}

install_or_update_cask() {
    program="$1"

    if brew list --cask $program >/dev/null 2>&1; then
        brew upgrade --cask $program
    else
        brew install --cask --force $program
    fi
}

install_or_update_formula() {
    program="$1"

    if brew list $program >/dev/null 2>&1; then
        brew upgrade $program
    else
        brew install --force $program
    fi
}

#### ACTUAL INSTALLATION ####

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# Add brew to rc files
brew_content="eval \"\$(/opt/homebrew/bin/brew shellenv)\""

insert_or_update_block "brew_zprofile" "$brew_content" $HOME/.zprofile
insert_or_update_block "brew_bash_profile" "$brew_content" $HOME/.bashrc

# Install zsh
install_or_update_formula

# Set shell to zsh
[[ $(basename "$SHELL") != "zsh" ]] && chsh -s $(which zsh)

# Install brew formulas
install_or_update_formula antigen
install_or_update_formula git
install_or_update_formula ca-certificates
install_or_update_formula cryptography
install_or_update_formula eza
install_or_update_formula autoenv
install_or_update_formula telnet
install_or_update_formula awscli
install_or_update_formula libpq
install_or_update_formula autojump
install_or_update_formula autossh
install_or_update_formula doctl
install_or_update_formula helm
install_or_update_formula openjdk
install_or_update_formula rclone
install_or_update_formula tree
install_or_update_formula mas

softwareupdate --install-rosetta --agree-to-license

# Mac apps
install_or_update_cask bruno
install_or_update_cask alt-tab
install_or_update_cask insomnia
install_or_update_cask arc
install_or_update_cask 1password
install_or_update_cask beekeeper-studio
install_or_update_cask free-download-manager
install_or_update_cask iina
install_or_update_cask iterm2
install_or_update_cask lens
install_or_update_cask obsidian
install_or_update_cask raycast
install_or_update_cask rectangle-pro
install_or_update_cask whatsapp
install_or_update_cask the-unarchiver
install_or_update_cask transmit
install_or_update_cask visual-studio-code
install_or_update_cask webstorm
install_or_update_cask zoom
install_or_update_cask meetingbar
install_or_update_cask bartender
install_or_update_cask ultimaker-cura
install_or_update_cask spotify
install_or_update_cask ghostty

# Mac App Store
mas install 937984704  # Amphetamine
mas install 497799835  # xcode
mas install 1450874784 # transporter
mas install 6469755356 # big red warning

curl -o $HOME/.zshrc -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.zshrc
curl -o $HOME/.bash_aliases -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/bash_aliases.sh
curl -o $HOME/.bash_functions -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/bash_fuctions.sh
curl -o $HOME/.vimrc -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.vimrc
curl -o $HOME/.gitconfig -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.gitconfig

mkdir -p $HOME/.dotfiles
touch $HOME/.dotfiles/.zshrc # Create local file, for local config

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

#### Mac os

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
