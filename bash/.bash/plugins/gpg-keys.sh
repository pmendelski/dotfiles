#!/usr/bin/env bash

gpg-default-key-id() {
  gpg --list-keys --keyid-format short | grep "^pub" | sed -En 's|^.*/([^ ]*).*$|\1|p' | head -n 1
}

gpg-default-key-id-long() {
  gpg --list-keys --keyid-format long | grep "^pub" | sed -En 's|^.*/([^ ]*).*$|\1|p' | head -n 1
}

gpg-list-keys() {
  gpg --list-keys --keyid-format short
}

gpg-list-keys-long() {
  gpg --list-keys --keyid-format long
}

gpg-show-key() {
  local id="${1:?Expected key id}"
  gpg --armor --export $id
}

gpg-show-default-key() {
  gpg-show-key "$(gpg-default-key-id)"
}

gpg-delete-key() {
  local id="${1:?Expected key id}"
  gpg --delete-secret-key $id
  gpg --delete-key $id
}

gpg-delete-default-key() {
  gpg-delete-key "$(gpg-default-key-id)"
}

gpg-send-key-to-keyserver() {
  local id="${1:?Expected key id}"
  gpg --keyserver hkp://pool.sks-keyservers.net --send-keys $id
}

gpg-send-default-key-to-keyserver() {
  gpg-send-key-to-keyserver "$(gpg-default-key-id)"
}

gpg-generate-default-key() {
  gpg --default-new-key-algo rsa4096 --gen-key \
    && git config --global user.signingkey "$(gpg-default-key-id)" \
    && gpg-send-key-to-keyserver "$(gpg-default-key-id)"
}

gpg-refresh-expired-keys() {
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
