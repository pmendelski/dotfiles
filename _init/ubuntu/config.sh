#!/usr/bin/env bash
set -euf -o pipefail

declare -r PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

echo -e "\n>>> Copy conky config"
ln -fs "$PWD/conky" "$HOME/.conky"

echo -e "\n>>> Copy template files"
cp "$PWD/templates/"* "$HOME/Templates/"

echo -e "\n>>> Copy template files"
rm -r "$HOME/.local/share/nautilus/scripts"
ln -fs "$PWD/nautilus" "$HOME/.local/share/nautilus/scripts"

echo -e "\n>>> Set ZSH as default shell"
chsh -s "$(which zsh)"

# Install One Dark and One Light terminal colorscheme
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-light.sh)"

# Create ssh key
if [ ! -f ~/.ssh/config ]; then
  echo -e "\n >>> Generating initial ssh key"
  eval "$(ssh-agent -s)"
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519
  echo "Host *" > ~/.ssh/config
  echo "  IgnoreUnknown UseKeychain" >> ~/.ssh/config
  echo "  AddKeysToAgent yes" >> ~/.ssh/config
  echo "  UseKeychain yes" >> ~/.ssh/config
  echo "  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config

  if command -v xclip &> /dev/null; then
    cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
    echo "New SSH key is in the clipboard. Register the key on https://github.com/settings/keys"
    echo "Remember to generate GPG key with one of following commands:"
    echo "  gpg --default-new-key-algo rsa4096 --gen-key"
    echo "  gpg --armor --export | xclip -selection clipboard"
  fi
fi
