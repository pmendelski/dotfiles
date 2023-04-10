#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"
source "$DIR/../bash/.bash/util/terminal.sh"

updatePlugins() {
  local -r dotfileDirs="$(find "$HOME/.zsh/deps" -mindepth 1 -maxdepth 1 -type d | sort)"
  for dir in $dotfileDirs; do
    if [ -d "$dir/.git" ]; then
      (cd "$dir" && git fetch --all && git reset --hard @{u})
    fi
  done
}

if command -v zsh &>/dev/null; then
  installPlugins
  updatePlugins
  printSuccess "Updated: zsh"
else
  printInfo "Skipped updating: zsh. Command not found."
fi
