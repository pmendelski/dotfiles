#!/usr/bin/env bash
set -euf -o pipefail

exists() {
  git show "$1" 1>/dev/null 2>/dev/null;
};

prevCommit() {
  local branch="$1";
  [ -z "$branch" ] && {
    echo "Please specify branch for prev commit."
    exit 1;
  };
  exists "$branch" || {
    echo "Could not find specified branch: $branch"
    exit 1;
  };
  local hash="$(git curr-commit)";
  local prev="$(git rev-list --topo-order "$branch" | grep $hash -A 1 | grep -v $hash)";
  if [ -n "$prev" ]; then
    echo "Checking out the previous non-merge commit:";
    git checkout $prev;
  else
    echo "No previous commit available";
    exit 1;
  fi;
};

prevCommit "$@"
