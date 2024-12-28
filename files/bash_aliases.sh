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

# Untar file
alias untar='tar -zxvf $1'

# AWS Vault
alias av="aws-vault"
alias aws="aws-vault exec $ACTIVE_AWS_PROFILE -- aws"
