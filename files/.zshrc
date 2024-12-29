# Antigen

source $HOMEBREW_PREFIX/share/antigen/antigen.zsh

antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen theme spaceship-prompt/spaceship-prompt

antigen apply

# psql
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# autojump
[ -f \$HOMEBREW_PREFIX/etc/profile.d/autojump.sh ] && . \$HOMEBREW_PREFIX/etc/profile.d/autojump.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Aliases
source ~/.bash_functions
source ~/.bash_aliases
source ~/.dotfiles/.zshrc
