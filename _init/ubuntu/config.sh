#!/usr/bin/env bash
set -e
declare -r PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

# Copy conky config
ln -fs "$PWD/conky" "$HOME/.conky"

# Copy template files
cp "$PWD/templates/"* "$HOME/Templates/"

# Set ZSH as default shell
chsh -s "$(which zsh)"
zsh
