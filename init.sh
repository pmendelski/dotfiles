#!/usr/bin/env bash
# shellcheck disable=SC2012
set -euf -o pipefail

if [ "$(bash --version | grep -o -E '[0-9]+' | head -n 1)" -lt 4 ]; then
  echo "Script requires Bash at least v4. Got bash version: $(bash --version)"
  exit 1
fi

# Constant values
declare -r INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")/_init"

# Make sure we're in the init directory
cd "$INIT_DIR"

init() {
  local system="$1"
  if [ -z "$system" ] || [ ! -d "$INIT_DIR/$system" ]; then
    echo "Expected system as a parameter."
    echo "  Example: init.sh ubuntu-server"
    echo "  Available system inits: $(ls "$INIT_DIR" | tr '\n' ' ')"
    exit 1
  fi
  cd "$INIT_DIR/$system"
  echo "Initializing $system"
  bash "./init.sh" &&
    echo -e "\n\nSUCCESS: System initalized successfuly" ||
    echo -e "\n\nFAILURE: Initalizion failure"
}

init "$1"
