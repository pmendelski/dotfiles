#!/usr/bin/env bash

function moveWindow() {
  local index="${1:?Expected window index}"
  local currentIndex="$(tmux display-message -p '#I')"
  if [ -z "$currentIndex" ]; then
    echo "Not a tmux session" >&2
    return 1
  fi
  if tmux list-windows | grep -q "^$index:"; then
    while [ "$currentIndex" -lt "$index" ]; do
      tmux swap-window -t +1
      tmux select-window -t +1
      currentIndex=$((currentIndex + 1))
    done
    while [ "$currentIndex" -gt "$index" ]; do
      tmux swap-window -t -1
      tmux select-window -t -1
      currentIndex=$((currentIndex - 1))
    done
  else
    tmux move-window -t "$index"
  fi
}

moveWindow "$1"
