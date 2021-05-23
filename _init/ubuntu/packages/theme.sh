#!/usr/bin/env bash
set -e

echo ""
echo ">>>>"
echo ">>> THEME"
echo ">>>>"

echo -e "\n>>> Wallpapers"
sudo apt-get install -y \
  ubuntu-wallpapers-karmic \
  ubuntu-wallpapers-lucid \
  ubuntu-wallpapers-maverick \
  ubuntu-wallpapers-natty \
  ubuntu-wallpapers-oneiric \
  ubuntu-wallpapers-precise \
  ubuntu-wallpapers-quantal \
  ubuntu-wallpapers-raring \
  ubuntu-wallpapers-saucy \
  ubuntu-wallpapers-trusty \
  ubuntu-wallpapers-utopic \
  ubuntu-wallpapers-vivid \
  ubuntu-wallpapers-wily \
  ubuntu-wallpapers-xenial \
  ubuntu-wallpapers-bionic \
  ubuntu-wallpapers-artful

echo -e "\n>>> Community Theme"
sudo snap install communitheme

echo -e "\n>>> Gnome Tweak Tool"
sudo apt-get install gnome-tweak-tool

echo -e "\n>>> Gnome extensions"
sudo apt-get install -y \
  gnome-shell-extensions \
  chrome-gnome-shell

# Install extensions:
# https://extensions.gnome.org/extension/744/hide-activities-button/
# https://extensions.gnome.org/extension/1732/gtk-title-bar/
# https://extensions.gnome.org/extension/1708/transparent-top-bar/
# https://extensions.gnome.org/extension/19/user-themes/
# https://extensions.gnome.org/extension/1319/gsconnect/
# https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec
# https://addons.mozilla.org/firefox/addon/gsconnect/

# Dark context menu:
# http://ubuntuhandbook.org/index.php/2020/04/dark-gnome-shell-menus-ubuntu-20-04/

# Needed for system monitor applet
# https://extensions.gnome.org/extension/120/system-monitor/ - it's the best but sometimes freezes
# https://extensions.gnome.org/extension/1043/gnomestatspro/ - alternative
# sudo apt-get install -y \
#   gir1.2-gtop-2.0 \
#   gir1.2-networkmanager-1.0 \
#   gir1.2-clutter-1.0
