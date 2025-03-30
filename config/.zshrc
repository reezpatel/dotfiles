if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS installation
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linuxbrew to path for Linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Antigen
source $HOMEBREW_PREFIX/share/antigen/antigen.zsh

antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme spaceship-prompt/spaceship-prompt

antigen apply

# psql
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# autojump
[ -f $HOMEBREW_PREFIX/etc/profile.d/autojump.sh ] && . $HOMEBREW_PREFIX/etc/profile.d/autojump.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Aliases
source ~/.dotfiles/config/bash_functions
source ~/.dotfiles/config/bash_aliases

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
