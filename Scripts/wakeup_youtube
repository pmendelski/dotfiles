#!/bin/bash

# Simple script that will wake you up with YouTube ;)
#
# Puts the computer on standby and automatically wakes it up at specified time and plays some music.
#
# Takes a 24hour time HH:MM as its argument
# Example:
# wakeup 9:30
# wakeup 18:45
# wakeup 18:45 2016-02-05
# wakeup 14:23 && echo "Finished"

# ------------------------------------------------------

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
source $DIR/suspend_until

# Clear the console
clear
echo "Goog Morning!"

links=(
    "https://www.youtube.com/watch?v=gU1ybiFHjJI" # Indiana Jones
    "https://www.youtube.com/watch?v=-bzWSJG93P8" # Star Wars
)
link="${links[$((RANDOM%${#links[*]}))]}"

# Set system volume
pactl set-sink-volume 0 100%
# Open browser
chromium-browser "link" &>/dev/null &
