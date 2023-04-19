#!/usr/bin/env bash

# Sleep command with datetime parameter
#
# Takes a 24hour time HH:MM and date YYYY-MM-DD as its arguments
# Example:
#   sleep_until 9:30
#   sleep_until 18:45
#   sleep_until 18:45 2016-02-05
#   sleep_until 14:23 && echo "Finished"
function sleep_until() {
  # Argument check
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: sleep_until HH:MM "
    echo "... or: sleep_until HH:MM YYYY-MM-DD"
    exit 1
  fi

  NOW=$(date +%s)
  if [ $# -eq 1 ]; then
    # Check whether specified time is today or tomorrow
    DESIRED="$(date +%s -d "$1")"
    if [ "$DESIRED" -lt "$NOW" ]; then
      DESIRED=$(($(date +%s -d "$1") + 24 * 60 * 60))
    fi
  else
    DESIRED=$(date +%s -d "$1 $2")
  fi
  echo "Wakeup time: $(date -d "@$DESIRED")"

  sleep $((DESIRED - NOW))
}
