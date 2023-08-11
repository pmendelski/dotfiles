#!/bin/bash

if type "snap" &>/dev/null; then
  # Removes old revisions of snaps
  # CLOSE ALL SNAPS BEFORE RUNNING THIS
  function snap-cleanup() {
    LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
      while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
      done
  }
fi
