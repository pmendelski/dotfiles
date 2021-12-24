#!/usr/bin/env bash
set -euf -o pipefail

installPlugins() {
  curl -fLo $HOME/.vim/plugins/vim-plug/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installPlugins
