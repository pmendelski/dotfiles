#!/usr/bin/env bash

function gerrit-init() {
  local host="${1:-$GERRIT_HOST}"
  if [ -z "$host" ]; then
    echo "Expected gerrit host as command argument or env variable GERRIT_HOST" >&2
    return 1
  fi
  local gitdir="$(git rev-parse --show-toplevel --git-dir | tail -n 1)"
  if [ ! $? -eq 0 ]; then
    echo "Not in a git repository" >&2
    return 1
  fi
  echo "Using gerrit host: $host"
  curl -Lo "$gitdir/hooks/commit-msg" "$host/tools/hooks/commit-msg" 2>/dev/null
  chmod u+x "$gitdir/hooks/commit-msg"
  echo "Gerrit repo initialized"
}
