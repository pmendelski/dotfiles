#!/bin/bash

function loadBash() {
    declare -r DIR="$HOME/.bash"

    # Load dotfiles
    source "$DIR/exports.sh"
    source "$DIR/aliases.sh"

    # Load functions
    for file in $DIR/func/*.sh; do
        source $file
    done
    # Load lib
    for file in $DIR/lib/*.sh; do
        source $file
    done
    # Load plugins
    if [ -z $bash_plugins ]; then
        for file in $DIR/plugins/*.sh; do
            source $file
        done
    else
        for plugin in ${bash_plugins[@]}; do
            [ -r "$DIR/plugins/$plugin.sh" ] && source $DIR/plugins/$plugin.sh
        done
    fi

    source "$DIR/prompt.sh"
}
loadBash;
