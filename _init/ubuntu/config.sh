#!/usr/bin/env bash
set -e
declare -r PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

# Copy conky config
ln -fs "$PWD/conky" "$HOME/.conky"

# Copy template files
cp "$PWD/templates/"* "$HOME/Templates/"

# Copy template files
mkdir -p "$HOME/.local/share/nautilus/scripts"
cp "$PWD/nautilus/"* "$HOME/.local/share/nautilus/scripts/"

# Set ZSH as default shell
chsh -s "$(which zsh)"
zsh

# Install One Dark and One Light terminal colorscheme
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-light.sh)"
