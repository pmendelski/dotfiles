#!/bin/bash

ssh-generate() {
  local email=""
  while [ -z "$email" ]; do
    printf "Enter your email (john.doe@gmail.com): "
    read -r email
  done
  ssh-keygen -t rsa -b 4096 -C "$email" \
    && git config --global user.signingkey "$(gpg-key-id-long)"
}

ssh-show-key() {
  cat ~/.ssh/id_rsa.pub
}

gpg-generate-key() {
  gpg --default-new-key-algo rsa4096 --gen-key
}

gpg-key-id() {
  gpg --list-keys --keyid-format short | grep "^pub" | sed -En 's|^.*/([^ ]*).*$|\1|p'
}

gpg-key-id-long() {
  gpg --list-keys --keyid-format long | grep "^pub" | sed -En 's|^.*/([^ ]*).*$|\1|p'
}

gpg-show-key() {
  local id="$(gpg-key-id)"
  gpg --armor --export $id
}

gpg-delete-key() {
  local id="$(gpg-key-id)"
  gpg --delete-secret-key $id
  gpg --delete-key $id
}

gpg-send-key-to-keyserver() {
  local id="$(gpg-key-id)"
  gpg --keyserver hkp://pool.sks-keyservers.net --send-keys $id
}

gpg-refresh-keys() {
  echo -n "Expired Keys: "
  for expiredKey in $(gpg --list-keys | awk '/^pub.* \[expired\: / {id=$2; sub(/^.*\//, "", id); print id}' | fmt -w 999 ); do
    echo -n "$expiredKey"
    gpg --batch --quiet --delete-keys $expiredKey >/dev/null 2>&1 \
      && echo -n "(OK), " \
      || echo -n "(FAIL), "
  done
  echo "Removed expired keys"

  echo -n "Update Keys: "
  for keyid in $(gpg -k | grep ^pub | grep -v expired: | grep -v revoked: | cut -d/ -f2 | cut -d' ' -f1); do
    echo -n "$keyid"
    gpg --batch --quiet --edit-key "$keyid" check clean cross-certify save quit > /dev/null 2>&1 \
      && echo -n "(OK), " \
      || echo -n "(FAIL), "
  done
  echo "Updated expired keys"

  gpg --batch --quiet --refresh-keys > /dev/null 2>&1 \
    && echo "Refresh OK" \
    || echo "Refresh FAILED"
}
