#!/usr/bin/env bash

# Trims value
function trim() {
  echo -e "$(echo -e "$@" | \
    sed -e 's/[[:space:]]*$//' | \
    sed -e 's/^[[:space:]]*//')"
}

function slugify() {
  local -r text="$([ ! -t 0 ] && cat || echo "$1")"
  echo "$text" \
    sed -E \
      -e 's|^ +||g' \
      -e 's| +$||g' \
      -e 's|.|\L&|g' \
      -e 's|[- _\t]+|-|g' \
      -e 's|ą|a|g' \
      -e 's|ć|c|g' \
      -e 's|ę|e|g' \
      -e 's|ł|l|g' \
      -e 's|ń|n|g' \
      -e 's|ó|o|g' \
      -e 's|ś|s|g' \
      -e 's|[źż]|z|g' \
      -e 's|[^a-zA-Z0-9-]||g'
}
