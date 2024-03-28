#!/usr/bin/env bash
set -e

echo ""
echo ">>>>"
echo ">>> INTERNET"
echo ">>>>"

echo -e "\n>>> Browsers"
sudo snap install chromium
sudo snap install opera

echo -e "\n>>> Chrome"
(cd "$(mktemp -d)" &&
  wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
  sudo apt install ./chrome.deb)

echo -e "\n>>> Zoom"
(cd "$(mktemp -d)" &&
  wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb &&
  sudo apt install -y ./zoom.deb)

echo -e "\n>>> Zoom"
sudo snap install zoom-client

echo -e "\n>>> Torrent"
sudo apt install -y deluge

echo -e "\n>>> Dropbox"
sudo apt install -y nautilus-dropbox
