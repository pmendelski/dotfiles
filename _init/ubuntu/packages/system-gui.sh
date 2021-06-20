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
sudo ln -s /snap/sublime-text/current/opt/sublime_text/sublime_text /usr/local/bin/subl
sudo snap install code --classic
# Git merge tool
sudo apt-get install -y meld
# Sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

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
sudo snap install intellij-idea-community --classic

echo -e "\n>>> Nicer fonts"
sudo apt-get install -y fonts-inconsolata
sudo apt-get install -y fonts-firacode
installNerdFonts() {
  mkdir -p ~/.local/share/fonts
  local -r fonts=('DroidSansMono' 'FiraCode' 'Inconsolata')
  local -r dir="$(pwd)"
  local -r tmpdir="$(mktemp -d -t nerd-fonts-XXXXX)"
  cd "$tmpdir"
  # echo "Tmp: $tmpdir"
  for font in "${fonts[@]}"; do
    wget -O "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font.zip" \
      && unzip "$font.zip" -d ~/.local/share/fonts \
      && echo "Installed nerd font: $font"
  done
  rm -rf "$tmpdir"
  cd "$dir"
}
installNerdFonts

fc-cache -fv
echo "done!"
sudo fc-cache -fv

echo -e "\n>>> Nicer launcher"
sudo add-apt-repository -y ppa:agornostal/ulauncher
sudo apt -y update && sudo apt install -y ulauncher
