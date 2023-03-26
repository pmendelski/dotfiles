#!/usr/bin/env bash

if [ -d "$HOME/Dropbox" ]; then
  export NOTES="$HOME/Dropbox/Notes"
elif [ -d "$HOME/Documents" ]; then
  export NOTES="$HOME/Documents/Notes"
else
  export NOTES="$HOME/Desktop/Notes"
fi

alias notes="$EDITOR $NOTES"
