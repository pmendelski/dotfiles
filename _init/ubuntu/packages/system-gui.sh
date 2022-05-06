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
# VSCode
if ! command -v code &> /dev/null; then
  sudo snap install code --classic
  code --install-extension vadimcn.vscode-lldb # debug extension for rust debugging in nvim
  code --install-extension ms-python.vscode-pylance
  code --install-extension esbenp.prettier-vscode
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension golang.Go
  code --install-extension zhuangtongfa.Material-theme
  code --install-extension EditorConfig.EditorConfig
  code --install-extension rust-lang.rust
fi
# Git merge tool
sudo apt-get install -y meld
# Sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

echo -e "\n>>> DB Managers"
sudo snap install squirrelsql
sudo snap install redis-desktop-manager
sudo snap install robo3t-snap

echo -e "\n>>> MongoDb Compass"
if ! command -v mongodb-compass &> /dev/null; then
  (
    cd `mktemp -d` && \
    wget -O compass.deb \
      "$(curl -s "https://www.mongodb.com/try/download/compass" | \
      grep "window.__serverData" | \
      sed -nE "s|^[^{]*\{(.*)\}.*$|{\1}|p" | jq . | \
      grep -Po "https://downloads.mongodb.com/compass/mongodb-compass[-_]\d+(\.\d+){0,2}[-_.][^.]+\.deb" | \
      head -n 1)" && \
    sudo apt install -y ./compass.deb
  )
fi

echo -e "\n>>> IntelliJ Idea"
sudo snap install intellij-idea-community --classic

echo -e "\n>>> Github Desktop"
installGithubDesktop() {
  local path="$(curl -sL https://github.com/shiftkey/desktop/releases/latest | grep -o "/releases/download/.\+GitHubDesktop.\+\.deb" | head -n 1)"
  local file="$(echo "$path" | grep -o "GitHubDesktop.\+\.deb" | head -n 1)"
  local tmpdir="$(mktemp -d -t github-desktop-XXXX)"
  (cd "$tmpdir" && wget -O "$file" "https://github.com/shiftkey/desktop${path}" && sudo gdebi -y "$file")
  rm -rf "$tmpdir"
}
if ! command -v github-desktop &> /dev/null; then
  installGithubDesktop
fi

echo -e "\n>>> Nicer fonts"
sudo apt-get install -y fonts-inconsolata
sudo apt-get install -y fonts-firacode
sudo apt-get install -y fonts-hack-ttf
installNerdFonts() {
  mkdir -p ~/.local/share/fonts
  local -r dir="$(pwd)"
  local -r tmpdir="$(mktemp -d -t nerd-fonts-XXXXX)"
  cd "$tmpdir"
  for font in "$@"; do
    wget -O "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font.zip" \
      && unzip -o "$font.zip" -d ~/.local/share/fonts \
      && echo "Installed nerd font: $font"
  done
  rm -rf "$tmpdir"
  cd "$dir"
}
if [ ! -f "~/.local/share/fonts/Fira Code Retina Nerd Font Complete.ttf" ]; then
  installNerdFonts 'DroidSansMono' 'FiraCode' 'Hack' 'Inconsolata'
  fc-cache -fv
fi

echo -e "\n>>> VPN Netowork manager packages"
sudo apt-get -y install \
  network-manager-openvpn-gnome \
  network-manager-openvpn \
  network-manager-pptp \
  network-manager-vpnc
# sudo systemctl restart NetworkManager

echo -e "\n>>> Wireshark"
# https://ask.wireshark.org/questions/7523/ubuntu-machine-no-interfaces-listed
sudo apt-get install -y wireshark
sudo groupadd -f wireshark
sudo usermod -a -G wireshark $USER
sudo chgrp wireshark /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
