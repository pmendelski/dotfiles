#!/usr/bin/env bash

# just highlight test without filtering
function highlight() {
  [ -n "$1" ] || {
    echo "Missing parameter.\nExpected: highlight \"lorem\"" >&2;
    return 1;
  }
  local -r color="32" # green
  local -r fg_c=$(echo -e "\e[1;${color}m")
  local -r c_rs=$'\e[0m'
  sed -u s"/$1/$fg_c\0$c_rs/g"
}
