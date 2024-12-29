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
        log "File created: $file_path"
    else
        # Replace the existing block
        sed -i '' "/# INSERTED_BY_DOTFILE START $unique_id/,/# INSERTED_BY_DOTFILE END $unique_id/d" "$file_path"

        # Use cat to append the content at the end of the file
        cat >>"$file_path" <<EOF
# INSERTED_BY_DOTFILE START $unique_id
$content
# INSERTED_BY_DOTFILE END $unique_id
EOF

        log "Block updated in: $file_path"
    fi
}

#### ACTUAL INSTALLATION ####

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# Add brew to rc files
brew_content="eval \"\$(/opt/homebrew/bin/brew shellenv)\""

insert_or_update_block "brew_zprofile" "$brew_content" "~/.zprofile"
insert_or_update_block "brew_bash_profile" "$brew_content" "~/.bashrc"

# Install zsh
bew install zsh

# Set shell to zsh
[[ $(basename "$SHELL") != "zsh" ]] && chsh -s $(which zsh)

# Install brew formulas
brew install antigen git ca-certificates cryptography eza autoenv
brew install telnet awscli libpq autojump autossh doctl helm openjdk rclone tree mas

softwareupdate --install-rosetta --agree-to-license

# Mac apps
brew install --cask bruno alt-tab insomnia arc 1password beekeeper-studio free-download-manager
brew install --cask ina iterm2 lens obsidian raycast rectangle-pro spotify whatsapp the-unarchiver
brew install --cask transmit visual-studio-code webstorm zoom meetingbar bartender ultimaker-cura

# Mac App Store
mas install 937984704  # Amphetamine
mas install 497799835  # xcode
mas install 1450874784 # transporter
mas install 6469755356 # big red warning

curl -o ~/.zshrc -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.zshrc
curl -o ~/.bash_aliases -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/bash_aliases.sh
curl -o ~/.bash_functions -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/bash_fuctions.sh
curl -o ~/.vimrc -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.vimrc
curl -o ~/.gitconfig -L https://raw.githubusercontent.com/reezpatel/dotfiles/main/files/.gitconfig

mkdir -p ~/.dotfiles
touch ~/.dotfiles/.zshrc # Create local file, for local config

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

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

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

# Disable local Time Machine backups
hash tmutil &>/dev/null && sudo tmutil disablelocal
