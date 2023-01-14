#!/usr/bin/env bash

ssh-generate-default-key() {
  local -r email="${1:?Expected email}"
  ssh-keygen -t ed25519 -C "$email"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  git config --global user.signingkey "$(gpg-default-key-id)"
}

ssh-show-default-key() {
  ssh-show-key "id_rsa"
}

ssh-show-default-key-hex() {
  ssh-show-key-hex "id_rsa"
}

ssh-show-key() {
  cat "$HOME/.ssh/${1?:Expected key name}.pub"
}

ssh-show-key-hex() {
  awk '{print $2}' "$HOME/.ssh/${1?:Expected key name}.pub" | base64 -d | md5sum | sed 's/../&:/g; s/: .*$//'
}

ssh-generate-key() {
  local -r email="${1:?Expected email}"
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_$email"
  ssh-add "$HOME/.ssh/id_$email"
}
