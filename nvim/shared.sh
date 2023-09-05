#!/usr/bin/env bash
set -euf -o pipefail

declare -r SDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$SDIR/../bash/.bash/util/terminal.sh"

installNvimDependencies() {
  printInfo "Installing nvim dependencies"
  for file in $(find "$SDIR/deps" -mindepth 1 -maxdepth 1 -type f | sort | sed -n "s|^.*/||p"); do
    printInfo "Installing nvim dependency: $file"
    if "$SDIR/deps/$file"; then
      printSuccess "Installed nvim dependency: $file"
    else
      printError "Could not install nvim dependency: $file"
    fi
  done
  printInfo "To reinstall nvim dependencies run: nvim-install-deps"
  printInfo "...or reinstall single nvim dependency with: nvim-install-dep NAME"
}

installNvimPlugins() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r packerDir="$dataDir/site/pack/packer/start/packer.nvim"
  if [ ! -d "$packerDir" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packerDir"
    printSuccess "Installed Packer - Nvim Package manager"
  fi
}

linkConfig() {
  local -r configDir="$(nvim --cmd ":echo stdpath('config')" --cmd "qall" --headless 2>&1)"
  mkdir -p "$(dirname "$configDir")"
  if [ ! -L "$configDir" ]; then
    ln -fs ~/.nvim "$configDir"
  fi
}

installNvim() {
  linkConfig
  installNvimDependencies
  installNvimPlugins
  # Update treeSitters modules
  nvim -c ":TSUpdate all" -c "q" --headless 2>&1
  echo "" # add missing new line after: nvim -c ...
}
