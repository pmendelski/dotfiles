#!/bin/bash

function loadBashFiles() {
    local -r DIR="$1"
    local -r NAMES=$2
    [ ! -d "$DIR" ] && return;

    if [ -z $NAMES ]; then
        for file in $DIR/*.sh; do
            source $file
        done
    else
        for plugin in ${NAMES[@]}; do
            [ ${plugin:0:1} -ne "!" ] \
                && [ -r "$DIR/$plugin.sh" ] \
                && source $DIR/$plugin.sh
        done
    fi
}

function loadLocalBashDotFiles() {
    for file in $HOME/.bash_{exports,aliases,functions,prompt}; do
        [ -r "$file" ] && source "$file"
    done
    unset file
}

function loadBash() {
    local -r DIR="$HOME/.bash"
    source "$DIR/exports.sh"
    source "$DIR/aliases.sh"
    loadLocalBashDotFiles
    [ -n "$BASH_VERSION" ] && loadBashFiles "$DIR/config"
    loadBashFiles "$DIR/func"
    loadBashFiles "$DIR/plugins" $bash_plugins
    [ -n "$BASH_VERSION" ] && source "$DIR/prompts/custom.sh" "pure"
}

loadBash
