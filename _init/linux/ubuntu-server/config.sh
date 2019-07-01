#!/bin/bash -ex

echo "Turnoff sleep mode on lid close"
if ! grep -q '^HandleLidSwitch=ignore' /etc/systemd/logind.conf; then
  # https://askubuntu.com/a/594417
  echo 'HandleLidSwitch=ignore' | sudo tee --append /etc/systemd/logind.conf
  echo 'HandleLidSwitchDocked=ignore' | sudo tee --append /etc/systemd/logind.conf
  sudo service systemd-logind restart
fi
