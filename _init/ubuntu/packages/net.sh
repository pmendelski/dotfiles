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
(cd `mktemp -d` && \
wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
sudo apt install ./chrome.deb)

echo -e "\n>>> Zoom"
(cd `mktemp -d` && \
wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb && \
sudo apt install -y ./zoom.deb)

echo -e "\n>>> Skype"
sudo snap install skype --classic

echo -e "\n>>> Zoom"
sudo snap install zoom-client

echo -e "\n>>> Torrent"
sudo apt install -y deluge

echo -e "\n>>> Dropbox"
sudo apt install -y nautilus-dropbox

echo -e "\n>>> TeamViewer"
(cd `mktemp -d` && \
wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc && \
sudo apt-key add TeamViewer2017.asc && \
sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list')
sudo apt update
sudo apt install -y teamviewer
