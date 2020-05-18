#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> SYSTEM GUI"
echo ">>>"

echo -e "\n>>> Conky"
sudo apt-get install -y conky conky-all

echo -e "\n>>> Password manager"
sudo snap install keepassxc

echo -e "\n>>> Editors"
sudo apt-get install -y gedit-plugins
sudo snap install sublime-text --classic
sudo snap install code --classic
# Git merge tool
sudo apt-get install -y meld

echo -e "\n>>> VPN Netowork manager packages"
sudo apt-get -y install \
  network-manager-openvpn-gnome \
  network-manager-openvpn \
  network-manager-pptp \
  network-manager-vpnc
sudo systemctl restart NetworkManager

echo -e "\n>>> Wireshark"
# https://ask.wireshark.org/questions/7523/ubuntu-machine-no-interfaces-listed
sudo apt-get install -y wireshark
sudo groupadd -f wireshark
sudo usermod -a -G wireshark $USER
sudo chgrp wireshark /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

echo -e "\n>>> DB Managers"
sudo snap install squirrelsql
sudo snap install redis-desktop-manager
sudo snap install robo3t-snap

echo -e "\n>>> MongoDb Compass"
(cd `mktemp -d` && pwd && \
wget -O compass.deb "$(curl "https://www.mongodb.com/download-center/compass" | \
  sed -nE "s|.*window.__serverData = (\{.*)</script>|\1|p" | jq . | \
  grep -Po "https://downloads.mongodb.com/compass/mongodb-compass[-_]\d+(\.\d+){0,2}[-_.][^.]+\.deb")" && \
sudo apt install -y ./compass.deb)

echo -e "\n>>> IntelliJ Idea"
sudo snap install intellij-idea-ultimate --classic
sudo snap install intellij-idea-community --classic

echo -e "\n>>> Nicer fonts"
sudo apt-get install -y fonts-inconsolata
sudo apt-get install -y fonts-firacode
sudo fc-cache -fv
