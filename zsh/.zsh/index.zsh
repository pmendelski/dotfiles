#!/bin/zsh

function __loadZshFiles() {
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

function __loadLocalZshFiles() {
    for file in $HOME/.zsh_{exports,aliases,functions,prompt}; do
        [ -r "$file" ] && source "$file"
    done
    if [ -d "$HOME/.zsh_plugins" ]; then
        for file in $HOME/.zsh_plugins/*.zsh; do
            [ -r "$file" ] && source "$file"
        done
    fi
    unset file
}

function __loadZsh() {
    source "$HOME/.bash/index.sh"
    source "$HOME/.zsh/exports.zsh"
    source "$HOME/.zsh/aliases.zsh"
    __loadLocalZshFiles
    __loadZshFiles "$HOME/.zsh/lib"
    __loadZshFiles "$HOME/.zsh/plugins" $zsh_plugins
}

__loadZsh
