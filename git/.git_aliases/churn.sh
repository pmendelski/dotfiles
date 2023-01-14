#!/usr/bin/env bash
set -euf -o pipefail

git --no-pager log --all --find-renames --find-copies --name-only --format='format:' "$@" |
  grep -Ev '^$' |
  sort |
  uniq -c |
  sort -nr
