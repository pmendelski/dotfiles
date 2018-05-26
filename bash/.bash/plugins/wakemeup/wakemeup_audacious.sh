#!/bin/bash -x

# Simple script that will wake you up with audacious ;)
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

audacious 1>/dev/null &

# Normalize volue level in all files
mp3gain -T -r $HOME/Music/Wakeup/*.mp3 &>/dev/null

# wait for audacious to start
sleep 1

# audacious & # Strat audacious
audtool playlist-clear 1>/dev/null # Clear playlist

# Add files to playlist
find "$HOME/Music/Wakeup" -maxdepth 1 -iname "*.mp3" -print0 | while read -d $'\0' file
do
  audtool playlist-addurl "file://${file}" # Add to playlist
done

# Repeat playlist
if [ "$(audtool playlist-repeat-status)" == "off" ]; then
  audtool playlist-repeat-toggle
fi;

# Shuffle playlist
if [ "$(audtool playlist-shuffle-status)" == "off" ]; then
  audtool playlist-shuffle-toggle
fi;

audtool playback-play
audtool mainwin-show on

# Set system volume
pactl set-sink-volume 0 100%

# Increasing player volume
VOLUME=50
CURR_SONG="$(audtool current-song-filename)"

audtool set-volume "$VOLUME"
while [ "$VOLUME" -lt "100" ]; do
  while [ "$CURR_SONG" == "$(audtool current-song-filename)" ]; do
    sleep 1
  done;
  CURR_SONG="$(audtool current-song-filename)"
  VOLUME=$((VOLUME + 10))
  audtool set-volume "$VOLUME"
  echo "Icreased volume (${VOLUME}%) for $(audtool current-song)"
done;
