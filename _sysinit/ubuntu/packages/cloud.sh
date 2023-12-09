#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> CLOUD"
echo ">>>"

echo -e ">>> gcloud"
if [ ! -d "$HOME/.gcloud" ]; then
  GCLOUD_VERSION="$(
    curl -s "https://hub.docker.com/v2/repositories/google/cloud-sdk/tags/?page_size=1000" |
      jq '.results | .[] | .name' -r |
      sed 's/latest//' |
      grep -E "^[0-9]+.[0-9]+.[0-9]+$" |
      sort --version-sort |
      tail -n 1
  )"
  echo "Downloading gcloud v$GCLOUD_VERSION"
  cd "$(mktemp -d -t gcloud-XXX)" &&
    wget -O "gcloud.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-linux-$(uname -m).tar.gz" &&
    echo "Extracting gcloud v$GCLOUD_VERSION..." &&
    tar -xf "gcloud.tar.gz" &&
    mv ./google-cloud-sdk "$HOME/.gcloud" &&
    cd "$HOME/.gcloud" &&
    ./install.sh --usage-reporting false --install-python false --command-completion false --path-update false
  gcloud components install alpha
  gcloud components install beta
  gcloud components install cloud-run-proxy
fi
