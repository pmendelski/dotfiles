#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

linkFile() {
  local -r file="$HOME/.dotfiles/claude/$1"
  local -r target="$HOME/.claude/$1"
  if [ "$file" -ef "$target" ]; then
    printInfo "Symlink already exists: $file"
    return 0
  fi
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

linkDir() {
  local -r file="$HOME/.dotfiles/claude/$1"
  local -r target="$HOME/.claude/$1"
  if [ "$file" -ef "$target" ]; then
    printInfo "Symlink already exists: $file"
    return 0
  fi
  if [ -d "$target" ] || [ -L "$target" ]; then
    if [ -f "$target.bak" ] || [ -L "$target.bak" ]; then
      rm -r "$target.bak"
    fi
    mv "$target" "$target.bak"
    printInfo "Dir already exists. Created backup: ${target//$HOME/\~}.bak"
  else
    mkdir -p "$(dirname "$target")"
  fi
  ln -s "$file" "$target"
  printSuccess "Symlink: ${target//${HOME}/\~} → ${file//$HOME/\~}"
}

linkFile "settings.json"
linkDir "hooks"
linkDir "commands"

printSuccess "Installed: claude"
