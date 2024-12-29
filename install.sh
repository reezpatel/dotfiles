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

#### ACTUAL INSTALLATION ####

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# Add brew to rc files
brew_content="eval \"\$(/opt/homebrew/bin/brew shellenv)\""

insert_or_update_block "brew_zprofile" "$brew_content" $HOME/.zprofile
insert_or_update_block "brew_bash_profile" "$brew_content" $HOME/.bashrc

# Install zsh
brew install zsh

# Set shell to zsh
[[ $(basename "$SHELL") != "zsh" ]] && chsh -s $(which zsh)

# Install brew formulas
brew install
brew install antigen
brew install git
brew install ca-certificates
brew install cryptography
brew install eza
brew install autoenv
brew install telnet
brew install awscli
brew install libpq
brew install autojump
brew install autossh
brew install doctl
brew install helm
brew install openjdk
brew install rclone
brew install tree
brew install mas

softwareupdate --install-rosetta --agree-to-license

# Mac apps
brew install --cask bruno
brew install --cask alt-tab
brew install --cask insomnia
brew install --cask arc
brew install --cask 1password
brew install --cask beekeeper-studio
brew install --cask free-download-manager
brew install --cask ina
brew install --cask iterm2
brew install --cask lens
brew install --cask obsidian
brew install --cask raycast
brew install --cask rectangle-pro
brew install --cask spotify
brew install --cask whatsapp
brew install --cask the-unarchiver
brew install --cask transmit
brew install --cask visual-studio-code
brew install --cask webstorm
brew install --cask zoom
brew install --cask meetingbar
brew install --cask bartender
brew install --cask ultimaker-cura

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
