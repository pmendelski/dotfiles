#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

function linkConfig() {
  local -r configDir="$(nvim --cmd ":echo stdpath('config')" --cmd "qall" --headless 2>&1)"
  mkdir -p "$(dirname "$configDir")"
  if [ ! -L "$configDir" ]; then
    ln -fs ~/.nvim "$configDir"
  else
    printInfo "nvim config already installed"
  fi
}

if command -v nvim &>/dev/null && nvim --version &>/dev/null; then
  linkConfig
  printSuccess "Installed: nvim"
else
  printInfo "Skipped installation: nvim. Command not found."
fi
