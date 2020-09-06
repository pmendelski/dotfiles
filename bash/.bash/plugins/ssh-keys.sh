#!/usr/bin/env bash

ssh-generate-default-key() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter your email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email" \
    && git config --global user.signingkey "$(gpg-key-id-long)"
}

ssh-show-default-key() {
  ssh-show-key "id_rsa"
}

ssh-show-default-key-hex() {
  ssh-show-key-hex "id_rsa"
}

ssh-show-key() {
  cat ~/.ssh/${1?:Expected key name}.pub
}

ssh-show-key-hex() {
  awk '{print $2}' ~/.ssh/${1?:Expected key name}.pub | base64 -d | md5sum | sed 's/../&:/g; s/: .*$//'
}

ssh-generate-key() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email"
}
