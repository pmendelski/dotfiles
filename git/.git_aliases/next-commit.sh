#!/bin/bash

exists() {
    git show "$1" 1>/dev/null 2>/dev/null;
};

printOtherBranches() {
    local branch="$1";
    local hash="$(git curr-commit)";
    local branches="$(git branch --contains $hash | grep -v HEAD | grep -v "$branch" | sed 's|..||')";
    if [ -n "$branches" ]; then
        echo "";
        echo "There are other branches that contain the current commmit:";
        for b in $branches; do
            echo "  $b";
        done;
    fi
}

nextCommit() {
    local branch="$1";
    [ -z "$branch" ] && {
        echo "Please specify branch for next commit."
        exit 1;
    };
    exists "$branch" || {
        echo "Could not find specified branch: $branch"
        exit 1;
    };
    local hash="$(git curr-commit)";
    local commits="$(git log "$branch" --format="%H")";
    local branchCommit="$(echo "$commits" | head -n 1)";
    local next="$(echo "$commits" | grep $hash -B 1 | head -n 1)";
    if [ "$branchCommit" = "$hash" ]; then
        echo "Branch points at current commit";
        git checkout "$branch";
        printOtherBranches "$branch";
    elif [ "$branchCommit" = "$next" ]; then
        echo "Branch points at next commit";
        git checkout "$branch";
        printOtherBranches "$branch";
    elif [ -n "$next" ]; then
        echo "Checking out the next commit";
        git checkout $next;
        printOtherBranches "$branch";
    else
        echo "Could not find next commit on branch:";
        echo "  $branch";
        echo "";
        echo "Current commit:";
        echo "  $hash";
        exit 1;
    fi;
};

nextCommit "$@"
