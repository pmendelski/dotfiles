#!/usr/bin/env bash
set -e

echo ""
echo ">>>>"
echo ">>> MEDIA"
echo ">>>>"

echo -e "\n>>> Graphics"
sudo snap install inkscape
sudo apt install -y \
  gimp \
  gimp-data \
  gimp-plugin-registry \
  gimp-data-extras

echo -e "\n>>> Video"
# Best movie player
sudo snap install vlc
sudo snap install ffmpeg
# Subtitle downloader
sudo apt install qnapi
# Camera recorder
sudo apt install -y cheese
# Screen recorder
sudo apt install -y kazam
# Vide editing tool
sudo snap install shotcut --classic
# mpeg thumbnails
sudo apt install -y ffmpegthumbnailer

echo -e "\n>>> Music"
# Music tag tools
sudo snap install picard
# Music player
sudo apt install -y audacious
# Music editor
sudo snap install audacity
# Sound format converter
sudo apt install -y soundconverter
# Spotify
sudo snap install spotify

echo -e "\n>>> Ebooks"
# eBook reader
sudo apt install -y calibre

echo -e "\n>>> PDF"
sudo apt install poppler-utils

echo -e "\n>>> Flash cards"
sudo snap install anki-ppd
