#!/usr/bin/env bash

_rerun_action() {
  clear
  echo "> rerun ($(date)): $@"
  eval "$@"
}

_rerun_script() {
  clear
  echo "> rerun ($(date)): $@"
  $@
}

rerun() {
  local -r watchpath="$1"
  shift
  local -r action="$@"
  if [ -z "$watchpath" ] || [ ! -e "$watchpath" ]; then
    (>&2 echo "Missing path to watch.")
    exit 1;
  fi
  if [ -n "$action" ]; then
    _rerun_action "$action"
    inotifywait --quiet --recursive --monitor --event modify --format "%w%f" "$watchpath" \
      | while read change; do
        _rerun_action "$action"
      done
  elif [ -f "$watchpath" ]; then
    _rerun_script $watchpath
    inotifywait --quiet --monitor --event modify --format "%w%f" "$watchpath" \
      | while read change; do
        _rerun_script $watchpath
      done
  else
    (>&2 echo "Could not run empty action or execute a directory.")
    exit 1;
  fi
}
