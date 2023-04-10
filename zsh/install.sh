#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"
source "$DIR/../bash/.bash/util/terminal.sh"

if command -v zsh &>/dev/null; then
  installPlugins
  printSuccess "Installed: zsh"
else
  printInfo "Skipped installation: zsh. Command not found."
fi
