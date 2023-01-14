#!/usr/bin/env bash

_rerun_action() {
  clear
  echo "> rerun ($(date)): $*"
  eval "$*"
}

_rerun_script() {
  clear
  echo "> rerun ($(date)): $*"
  $1
}

rerun() {
  local -r watchpath="${1:?Expected path to watch}"
  shift
  local -r action="$*"
  if [ -z "$watchpath" ] || [ ! -e "$watchpath" ]; then
    (echo >&2 "Missing path to watch.")
    exit 1
  fi
  if [ -n "$action" ]; then
    _rerun_action "$action"
    inotifywait --quiet --recursive --monitor --event modify --format "%w%f" "$watchpath" |
      while read -r _change; do
        _rerun_action "$action"
      done
  elif [ -f "$watchpath" ]; then
    _rerun_script "$watchpath"
    inotifywait --quiet --monitor --event modify --format "%w%f" "$watchpath" |
      while read -r _change; do
        _rerun_script "$watchpath"
      done
  else
    (echo >&2 "Could not run empty action or execute a directory.")
    exit 1
  fi
}
