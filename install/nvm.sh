#!/bin/bash

# GROUP: node

source ./../utils.sh

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

content="
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"                   # This loads nvm
[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\" # This loads nvm bash_completion
"

config_file=$(get_shell_config_file)

insert_or_update_block "nvm_install" "$content" "$config_file"
