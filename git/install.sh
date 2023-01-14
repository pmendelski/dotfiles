#!/usr/bin/env bash
set -euf -o pipefail

source "./bash/.bash/util/terminal.sh"

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
