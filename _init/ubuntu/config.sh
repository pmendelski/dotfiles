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

# Create ssh key
if [ ! -f ~/.ssh/config ]; then
  echo "Generating initial ssh key"
  eval "$(ssh-agent -s)"
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519
  echo "Host *" > ~/.ssh/config
  echo "  IgnoreUnknown UseKeychain" >> ~/.ssh/config
  echo "  AddKeysToAgent yes" >> ~/.ssh/config
  echo "  UseKeychain yes" >> ~/.ssh/config
  echo "  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config

  if command -v pbcopy &> /dev/null; then
    cat ~/.ssh/id_ed25519 | pbcopy
    echo "New SSH key is in the clipboard. Register the key on https://github.com/settings/keys"
    echo "Remember to generate GPG key with: gpg-generate-key-for-github"
  fi
fi

# sdkvm
git clone git@github.com:pmendelski/sdkvm.git "$HOME/.sdkvm"
