#!/usr/bin/env bash

if type "apt-get" &> /dev/null; then
  update() {
    echo "Updating all system packages"
    sudo apt-get update
    sudo apt-get upgrade
    sudo snap refresh
  }
fi
