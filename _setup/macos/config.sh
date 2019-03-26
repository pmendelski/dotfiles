#!/bin/bash

# Make dock autohide faster
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
killall Dock 

# Pesent hidden files in finder
defaults write com.apple.Finder AppleShowAllFiles true
killall Finder