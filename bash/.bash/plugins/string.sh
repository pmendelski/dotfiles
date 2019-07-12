#!/usr/bin/env bash

# Trims value
function trim() {
  echo -e "$(echo -e "$@" | \
    sed -e 's/[[:space:]]*$//' | \
    sed -e 's/^[[:space:]]*//')"
}
