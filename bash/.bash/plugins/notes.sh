#!/usr/bin/env bash

function notes() {
  if [ -d "$HOME/Dropbox" ]; then
    nvim "$HOME/Dropbox/Notes"
  elif [ -d "$HOME/Documents" ]; then
    nvim "$HOME/Documents/Notes"
  else
    nvim "$HOME/Desktop/Notes"
  fi
}
