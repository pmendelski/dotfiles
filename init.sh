#!/bin/bash

init() {
  echo "Initializing $system"
  local -r system="${1:?Expected system}"
  bash "./_init/${system}/init.sh"
  echo "System initalized"
}

case "$OSTYPE" in
  darwin*) init "macos";;
  *) echo "Unsupported system: $OSTYPE" ;;
esac