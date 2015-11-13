#!/bin/bash

# Simple calculator
function calc() {
    local result="";
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
    #                       └─ default (when `--mathlib` is used) is 20
    #
    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
            sed -e 's/^\./0./'       # add "0" for cases like ".5"` \
                -e 's/^-\./-0./'      # add "0" for cases like "-.5"`\
                -e 's/0*$//;s/\.$//'; # remove trailing zeros
    else
        printf "$result";
    fi;
    printf "\n";
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* *;
    fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@";
    }
fi;

# Compare original and gzipped file size
function gzcompare() {
    local origsize=$(wc -c < "$1");
    local gzipsize=$(gzip -c "$1" | wc -c);
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}


# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Trims value
function trim() {
    echo -e "$(echo -e "$@" | \
        sed -e 's/[[:space:]]*$//' | \
        sed -e 's/^[[:space:]]*//')"
}

# Like PWD but with ~ as home directory
function shortPwd() {
    local dir="$PWD"
    [[ "$dir" =~ ^"$HOME"(/|$) ]] && dir="~${dir#$HOME}"
    [[ "$dir" = "~/" ]] && dir="~"
    echo "$dir"
}
