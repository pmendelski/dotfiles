#!/bin/bash

findPrevTag() {
    local branch="$1";
    local hash="$(git curr-commit)";
    local tags="$(git show-ref --tags)";
    git rev-list --topo-order "$branch" |
    sed -n "/$hash/,\$p" |
    (git symbolic-ref --short HEAD 1>/dev/null 2>/dev/null && cat || grep -v "$hash") |
    while read commit; do
        echo "$tags" | grep "^$commit" | sed -E 's|^([^ ]+) refs/tags/(.+)|\2|';
    done | head -n 1;
}

exists() {
    git show "$1" 1>/dev/null 2>/dev/null;
};

prevTag() {
    local branch="$1";
    [ -z "$branch" ] && {
        echo "Please specify branch for next commit."
        exit 1;
    };
    exists "$branch" || {
        echo "Could not find specified branch: $branch"
        exit 1;
    };
    local prevTag="$(findPrevTag "$branch")";
    if [ -n "$prevTag" ]; then
        echo "Checking out the previous tag: $prevTag";
        git checkout $prevTag;
    else
        echo "Could not find previous tag on branch:";
        echo "  $branch";
        echo "";
        exit 1;
    fi;
}

prevTag "$@";
