# Better ls
alias ls="eza --color --grid  -F --hyperlink --group-directories-first -l --no-filesize -m --no-permissions --no-user --no-time"

# List files in details
alias ll="eza -1 --color -F --hyperlink --group-directories-first -l --no-filesize -m --no-permissions --group -o --icons --git"

# Random string `rand 10`
alias rand="openssl rand -hex"

# Generate UUID
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'

# Movement
alias ..="cd .."
alias ...='cd ../..'

# Untar file
alias untar='tar -zxvf $1'

# AWS Vault
alias av="aws-vault"
alias aws="aws-vault exec $ACTIVE_AWS_PROFILE -- aws"

# File Management
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias trash='mv -t ~/.Trash/'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# git
alias g="git"
alias ga="git add"
alias gc="git commit"

alias gaa="git add -A"
alias gcm="git checkout main"
alias gfm="git fetch origin main"
alias gmm="git merge origin/main"
alias gpm="git pull origin main -r"
alias gpo='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gmc="git merge --continue"
alias gcp="git cherry-pick"

alias gcpc="git cherry-pick --continue"
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
