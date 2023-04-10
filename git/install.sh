#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

initFile() {
  local -r file="git/_$1"
  local -r target="$HOME/.$1"
  if [ ! -f "$target" ]; then
    cp "$file" "$target"
    printSuccess "Created: ~/.$1"
  else
    printInfo "File already exists. Skipping: ~/.$1"
  fi
}

initFile "gitconfig"

printSuccess "Installed: git"
