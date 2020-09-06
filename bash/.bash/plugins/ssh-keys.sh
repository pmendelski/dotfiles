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
  cat ~/.ssh/id_rsa.pub
}

ssh-show-default-key-hex() {
  awk '{print $2}' ~/.ssh/id_rsa.pub | base64 -d | md5sum | sed 's/../&:/g; s/: .*$//'
}

ssh-generate-key() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email"
}
