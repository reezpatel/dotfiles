# Run command multiple times
function x() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: repeat <number_of_times> <command>"
    return 1
  fi

  local count=$1
  shift 

  for ((i=1; i<=count; i++)); do
    eval "$@"  # Use 'eval' to expand aliases on macOS
  done
}