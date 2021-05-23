#!/usr/bin/env bash
source "./bash/.bash/util/terminal.sh"
set -euf -o pipefail

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

