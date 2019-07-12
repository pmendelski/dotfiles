#!/usr/bin/env bash -e
source "./bash/.bash/util/terminal.sh"

initFile() {
  local -r file="gradle/_gradle/$1"
  local -r target="$HOME/.gradle/$1"
  if [ ! -f "$target" ]; then
    cp "$file" "$target"
    printSuccess "Created: ~/.gradle/$1"
  else
    printInfo "File already exists. Skipping: ~/.gradle/$1"
  fi
}

mkdir -p "$HOME/.gradle"
initFile "init.d"
initFile "gradle.properties"
