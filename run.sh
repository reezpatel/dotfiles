#!/bin/bash

#----- CONFIGURATION VARIABLES ------

# Read Readme.md for more information

HOME_DIR=$HOME
GIT_REPO="https://github.com/reezpatel/dotfiles.git"
REPO_NAME="dotfiles"
MIN_WAIT_BEFORE_PULL=86400 # 24 hrs

#-----

#### DO NOT EDIT BELOW THIS LINE ####

verbose=0
force=0
script_dir=$(dirname "$(readlink -f "$0")")

function log() {
    if [[ "$verbose" -eq 1 ]]; then
        echo "$@"
    fi
}

while getopts "v" opt; do
    case "$opt" in
    v) verbose=1 ;;
    f) verbose=1 ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

log "Script directory: $script_dir"

shift $((OPTIND - 1))

if [[ "$0" == "bash" ]] || [[ "$0" == "sh" ]]; then
    echo "Cloning $REPO_NAME"

    if [[ "$verbose" -eq 1 ]]; then
        git clone "$GIT_REPO" "$HOME_DIR/$REPO_NAME"
    else
        git clone "$GIT_REPO" "$HOME_DIR/$REPO_NAME" >/dev/null 2>&1
    fi

    if [[ $? -ne 0 ]]; then # Check exit code of git clone
        echo "Error: Failed to clone repository. Exiting." >&2
        exit 1
    fi

    echo "Linking $REPO_NAME"
    sudo ln -s $HOME_DIR/$REPO_NAME/run.sh /usr/local/bin/dotfile

    exit 0
fi

function printHelp() {
    echo "Usage: dotfile [apply|pull|help] [-v]"
    echo ""
    echo "  apply [-f] [group1 group2 ...]  Apply latest changes, optionally specifying groups. Use -f to force pull and apply."
    echo "  pull [-f]                  Pull latest changes from the repository. Use -f to force pull."
    echo "  help                       Display this help message."
    echo "  -v                         Enable verbose logging."
}

ts_file="$script_dir/.ts" # timestamp file

function canPull() {
    if [[ "$force" -eq 1 ]]; then
        log "-f flag detected. Forcefully pulling"
        return 0 # 0 indicates we can pull
    fi

    if [[ ! -f "$ts_file" ]]; then
        # If the file doesn't exist, we can pull

        log "no timestamp file found. Forcefully pulling"

        date +%s >"$ts_file"

        return 0
    fi

    last_timestamp=$(cat "$ts_file")

    # Get the current timestamp
    current_timestamp=$(date +%s)

    # Calculate the time difference in seconds
    time_diff=$((current_timestamp - last_timestamp))

    if [[ $time_diff -ge $MIN_WAIT_BEFORE_PULL ]]; then
        log "Updating timestamp and pulling"

        # Update the timestamp file with the current timestamp
        date +%s >"$ts_file"

        return 0 # Can pull
    else
        log "Already up to date. Skipping pull"

        return 1 # Cannot pull
    fi
}

function pull() {
    log "Checking for updates..."

    if canPull; then
        log "Pulling latest changes"

        if [[ "$verbose" -eq 1 ]]; then
            (cd "$script_dir" && git pull -r origin main)
        else
            (cd "$script_dir" && git pull -r origin main) >/dev/null 2>&1
        fi

    fi
}

install_dir="$script_dir/install"

function execute_script() {
    local script_file="$1"
    local as_root="$2"

    if [[ "$as_root" == "AS_ROOT" ]]; then
        log "Executing $script_file as root..."
        sudo "$script_file"
    else
        log "Executing $script_file..."
        "$script_file"
    fi

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to execute $script_file. Exiting." >&2
        exit 1
    fi
}

function check_circular_deps() {
    local file="$1"
    local visited_files="$2"

    visited_files="$visited_files $file"

    # Get the dependencies for the current file
    local needs=$(head -n 5 "$file" | grep "^# NEEDS:" | cut -d ':' -f 2 | xargs)

    for need in $needs; do
        if [[ "$visited_files" == *"$need"* ]]; then
            echo "Error: Circular dependency detected with $file and $need" >&2
            exit 1
        fi

        check_circular_deps "$install_dir/$need.sh" "$visited_files"
    done
}

function apply() {
    pull

    groups="$@"

    find "$install_dir" -type f -name "*.sh" | while read -r script_file; do
        # Extract the script name without extension
        script_name=$(basename "$script_file" .sh)

        # Extract optional lines
        needs=$(grep "^# NEED:" "$script_file" | cut -d '"' -f 2)
        as_root=$(grep "^# AS_ROOT" "$script_file")
        group=$(grep "^# GROUP" "$script_file" | cut -d ' ' -f 2-)

        # Check for circular dependencies
        check_circular_deps "$script_file" ""

        # Execute the script based on conditions
        if [[ -n "$group" ]]; then
            # If GROUP is specified, check if it matches the provided groups or no group is provided
            if [[ -z "$groups" || "$groups" == *"$group"* ]]; then
                execute_script "$script_file" "$as_root"
            fi
        else
            # If no GROUP is specified, execute the script
            execute_script "$script_file" "$as_root"
        fi
    done
}

log "Running command: $1"

if [[ -z "$1" ]]; then
    echo "Unknown command: $1"
    printHelp
    exit 1
fi

command="$1"

shift

case "$command" in
apply)
    apply
    ;;
pull)
    pull
    ;;
help)
    printHelp
    ;;
*)
    echo "Unknown command: $1"
    printHelp
    exit 1
    ;;
esac
