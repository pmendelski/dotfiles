#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

updatePlugins() {
  local -r dotfileDirs="$(find "$HOME/.tmux/deps" -mindepth 1 -maxdepth 1 -type d | sort)"
  for dir in $dotfileDirs; do
    if [ -d "$dir/.git" ]; then
      (cd "$dir" && git fetch --all && git reset --hard origin/master)
    fi
  done
}

if command -v tmux &>/dev/null; then
  updatePlugins
  printSuccess "Updated: tmux"
else
  printInfo "Skipped updating: tmux. Command not found."
fi
