#!/usr/bin/env bash

# epoch - Epoch in milliseconds
# Usage:
#   epoch - prints milliseconds since 1970-01-01 00:00:00 UTC
if command -v gdate &>/dev/null; then
  epoch() {
    gdate +%s%3N
  }
else
  epoch() {
    date +%s%3N
  }
fi

# formatMs - Formats milliseconds in humanreadble minimized format
# Usage:
#   formatMsMin 10000000
#   2.76hr
formatMsMin() {
  local -i ms=$1
  local -i sec=$((ms / 1000))
  local -i min=$((sec / 60))
  local -i hrs=$((min / 60))
  local -i days=$((hrs / 24))
  ms=$((ms % 1000))
  sec=$((sec % 60))
  min=$((min % 60))
  hrs=$((hrs % 24))
  if [ $days -gt 0 ]; then
    printf "%d.%02dd" $days $((hrs * 100 / 24))
  elif [ $hrs -gt 0 ]; then
    printf "%d.%02dhr" $hrs $((min * 100 / 60))
  elif [ $min -gt 0 ]; then
    printf "%d.%02dm" $min $((sec * 100 / 60))
  elif [ $sec -gt 0 ]; then
    printf "%d.%02ds" $sec $((ms * 100 / 1000))
  else
    printf "%dms" $ms
  fi
}

# formatMs - Formats milliseconds in humanreadble format
# Format: <days>d<hours>:<minutes>:<seconds>.<millis>
# Usage:
#   formatMs 10000000
#   2:46:40.000
formatMs() {
  local -i ms=$1
  local -i sec=$((ms / 1000))
  local -i min=$((sec / 60))
  local -i hrs=$((min / 60))
  local -i days=$((hrs / 24))
  ms=$((ms % 1000))
  sec=$((sec % 60))
  min=$((min % 60))
  hrs=$((hrs % 24))
  if [ $days -gt 0 ]; then
    printf "%dd%02d:%02d:%02d.%03d" $days $hrs $min $sec $ms
  elif [ $hrs -gt 0 ]; then
    printf "%d:%02d:%02d.%03d" $hrs $min $sec $ms
  elif [ $min -gt 0 ]; then
    printf "%d:%02d.%03d" $min $sec $ms
  elif [ $sec -gt 0 ]; then
    printf "%d.%03d" $sec $ms
  else
    printf "%d" $ms
  fi
}
