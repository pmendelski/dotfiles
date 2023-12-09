#!/usr/bin/env bash
set -euf -o pipefail

../ubuntu/packages/system.sh
../ubuntu/packages/lang.sh
../ubuntu/packages/docker.sh

echo -e "\n>>> Server network tools"
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  iptables-persistent
