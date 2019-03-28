#!/bin/bash

init() {
  echo "Initializing $system"
  local -r system="${1:?Expected system}"
  bash "./_init/${system}/init.sh"
  echo "System initalized"
}

case "$OSTYPE" in
  darwin*) init "macos";;
  linux*) init "linux";;
  *) echo "Unsupported system: $OSTYPE" ;;
esac