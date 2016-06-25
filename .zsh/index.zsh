#!/bin/zsh

function loadZsh() {
    local -r BASHDIR="$HOME/.bash"
    local -r DIR="$HOME/.zsh"

    source "$BASHDIR/exports.sh"
    source "$DIR/exports.zsh"
    source "$BASHDIR/aliases.sh"
    source "$DIR/aliases.zsh"
    # Load bash functions (functions are shared)
    for file ($BASHDIR/func/*.sh); do
        source $file
    done
    # Load zsh functions
    for file ($DIR/func/*.zsh); do
        source $file
    done
    # Load bash plugins
    if [ -z $bash_plugins ]; then
        for file in $BASHDIR/plugins/*.sh; do
            source $file
        done
    else
        for plugin in ${bash_plugins[@]}; do
            [ -r "$BASHDIR/plugins/$plugin.sh" ] && source $BASHDIR/plugins/$plugin.sh
        done
    fi
    # Load zsh lib
    for file ($DIR/lib/*.zsh); do
        source $file
    done
    source "$DIR/prompt.zsh"
    source "$DIR/bundles.zsh"
}

loadZsh
