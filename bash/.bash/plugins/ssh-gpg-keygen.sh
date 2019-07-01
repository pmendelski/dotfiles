#!/bin/bash

ssh-generate() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter your email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email"
}

ssh-show() {
  cat ~/.ssh/id_rsa.pub
}

gpg-generate() {
  gpg --default-new-key-algo rsa4096 --gen-key
}

gpg-show() {
  local id="$(gpg --list-secret-keys --keyid-format LONG | grep sec | sed -En 's|^.*/([^ ]*).*$|\1|p')"
  gpg --armor --export $id
}
