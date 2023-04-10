#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

installPlugins() {
  mkdir -p ".vim/plugins"
  curl -fLo "$HOME/.vim/plugins/vim-plug/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c ':PlugInstall' -c 'qa!'
}

if command -v vim &>/dev/null; then
  installPlugins
  printSuccess "Installed: vim"
else
  printInfo "Skipped installation: vim. Command not found."
fi
