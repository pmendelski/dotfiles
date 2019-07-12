#!/usr/bin/env bash -e

# Suspends computer and automatically waits it up at specified date/time parameter
# Source: http://askubuntu.com/questions/61708/automatically-sleep-and-wake-up-at-specific-times
#
# Takes a 24hour time HH:MM and date YYYY-MM-DD as its arguments
# Example:
# suspend_until 9:30
# suspend_until 18:45
# suspend_until 18:45 2016-02-05
# suspend_until 14:23 && echo "Finished"
function suspend_until() {
  # Argument check
  if [ $# -lt 1 -o $# -gt 2 ]; then
    echo "Usage: sleep_until HH:MM "
    echo "... or: sleep_until HH:MM YYYY-MM-DD"
    exit
  fi

  NOW=$(date +%s)
  if [ $# -eq 1 ]; then
    # Check whether specified time is today or tomorrow
    DESIRED="$(date +%s -d "$1")"
    if [ $DESIRED -lt $NOW ]; then
      DESIRED=$((`date +%s -d "$1"` + 24*60*60))
    fi
  else
    DESIRED=$(date +%s -d "$1 $2")
  fi
  echo "Wakeup time: $(date -d @$DESIRED)"

  # Kill rtcwake if already running
  sudo killall rtcwake 2>/dev/null || true;

  # Set RTC wakeup time
  # N.B. change "mem" for the suspend option
  # find this by "man rtcwake"
  sudo rtcwake -l -m mem -t $DESIRED 1>/dev/null &

  # feedback
  echo "Suspending..."

  # give rtcwake some time to make its stuff
  sleep 2

  # then suspend
  # N.B. dont usually require this bit
  #sudo pm-suspend

  # Any commands you want to launch after wakeup can be placed here
  # Remember: sudo may have expired by now

  # Wake up with monitor enabled N.B. change "on" for "off" if
  # you want the monitor to be disabled on wake
  xset dpms force on
}
