#!/usr/bin/env bash
# shellcheck disable=SC2296,2298

# enable colors in ls
if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi
