#!/bin/zsh

function loadZshFiles() {
    local -r DIR="$1"
    local -r NAMES=$2
    [ ! -d "$DIR" ] && return;

    if [ -z $NAMES ]; then
        for file in $DIR/*.zsh; do
            source $file
        done
    else
        for plugin in ${NAMES[@]}; do
            [ ${plugin:0:1} -ne "!" ] \
                && [ -r "$DIR/$plugin.zsh" ] \
                && source $DIR/$plugin.zsh
        done
    fi
}

function loadLocalZshDotFiles() {
    for file in $HOME/.zsh_{exports,aliases,functions,prompt}; do
        [ -r "$file" ] && source "$file"
    done
    unset file
}

function loadZsh() {
    source "$HOME/.bash/index.sh"
    local -r DIR="$HOME/.zsh"
    source "$DIR/exports.zsh"
    source "$DIR/aliases.zsh"
    loadLocalZshDotFiles
    loadZshFiles "$DIR/config"
    loadZshFiles "$DIR/func"
    loadZshFiles "$DIR/plugins"
    source "$DIR/prompts/basic.zsh"
    source "$DIR/bundles.zsh"
}

loadZsh
