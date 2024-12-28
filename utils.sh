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
        sed -i '' -e "\$a# INSERTED_BY_DOTFILE START $unique_id" -e "\$a$content" -e "\$a# INSERTED_BY_DOTFILE END $unique_id" "$file_path"
        echo "Block updated in: $file_path"
    fi
}

function get_shell_config_file() {
    local shell_name=$(basename "$SHELL")

    case "$shell_name" in
    bash)
        # Check for Bash config files in order of preference
        if [[ -f "$HOME/.bash_profile" ]]; then
            echo "$HOME/.bash_profile"
        elif [[ -f "$HOME/.bashrc" ]]; then
            echo "$HOME/.bashrc"
        elif [[ -f "$HOME/.profile" ]]; then
            echo "$HOME/.profile"
        fi
        ;;

    zsh)
        echo "$HOME/.zshrc"
        ;;

    fish)
        echo "$HOME/.config/fish/config.fish"
        ;;

    *)
        echo "Unsupported shell: $shell_name" >&2
        return 1
        ;;
    esac
}
