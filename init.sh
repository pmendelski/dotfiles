#!/bin/bash

# Constant values
declare -r INIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )/_init"

# Make sure we're in the init directory
cd "$INIT_DIR"

init() {
  local system="$1"
  if [ -z "$system" ] || [ ! -d "$INIT_DIR/$system" ]; then
    echo "Expected system as a parameter."
    echo "  Example: init.sh ubuntu-server"
    echo "  Available system inits: $(ls $INIT_DIR | tr '\n' ' ')"
    exit 1
  fi
  cd "$INIT_DIR/$system"
  echo "Initializing $system"
  bash "./${system}/init.sh"
  echo "System initalized"
}

init $1
