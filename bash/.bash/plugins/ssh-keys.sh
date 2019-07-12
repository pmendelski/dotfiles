#!/bin/bash

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

ssh-generate-key() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email"
}
