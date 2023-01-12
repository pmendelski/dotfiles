#!/usr/bin/env bash
set -euf -o pipefail

findNextTag() {
  local branch="$1";
  local hash="$(git curr-commit)";
  local tags="$(git show-ref --tags)";
  git rev-list --topo-order "$branch" |
  sed -e "/$hash/,\$d" |
  tac |
  while read commit; do
    echo "$tags" | grep "^$commit" | sed -E 's|^([^ ]+) refs/tags/(.+)|\2|';
  done | head -n 1;
}

exists() {
  git show "$1" 1>/dev/null 2>/dev/null;
};

nextTag() {
  local branch="$1";
  [ -z "$branch" ] && {
    echo "Please specify branch for next commit."
    exit 1;
  };
  exists "$branch" || {
    echo "Could not find specified branch: $branch"
    exit 1;
  };
  local nextTag="$(findNextTag "$branch")";
  if [ -n "$nextTag" ]; then
    echo "Checking out the next tag: $nextTag";
    git checkout $nextTag;
  else
    echo "Could not find next tag on branch:";
    echo "  $branch";
    echo "";
    exit 1;
  fi;
}

nextTag "$@";
