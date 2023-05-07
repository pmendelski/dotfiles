#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

linkFile() {
  local -r file="$HOME/.dotfiles/common/$1"
  local -r target="$2"
  if [ -f "$target" ] || [ -L "$target" ]; then
    if [ -f "$target.bak" ] || [ -L "$target.bak" ]; then
      rm "$target.bak"
    fi
    mv "$target" "$target.bak"
    printInfo "File already exists. Created backup: ${target//$HOME/\~}.bak"
  else
    mkdir -p "$(dirname "$target")"
  fi
  ln -s "$file" "$target"
  printSuccess "Symlink: ${target//${HOME}/\~} → ${file//$HOME/\~}"
}

linkFile "bat.conf" "$HOME/.config/bat/config"
linkFile "ranger.conf" "$HOME/.config/ranger/rc.conf"

printSuccess "Installed: common"
