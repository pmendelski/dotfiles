#!/usr/bin/env bash
set -e
declare -r PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

# Copy conky config
ln -fs "$HOME/.conky" "$PWD/conky/.conky"

# Set ZSH as default shell
chsh -s "$(which zsh)"
zsh