#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"
source "$DIR/../bash/.bash/util/terminal.sh"

if command -v nvim &>/dev/null; then
  installNvim
  printSuccess "Installed: nvim"
else
  printInfo "Skipped installation: nvim. Command not found."
fi
