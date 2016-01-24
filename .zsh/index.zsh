#!/bin/zsh

function loadZsh() {
    local -r BASHDIR="$HOME/.bash"
    local -r DIR="$HOME/.zsh"

    source "$BASHDIR/exports.sh"
    source "$DIR/exports.zsh"
    source "$BASHDIR/aliases.sh"
    source "$DIR/aliases.zsh"
    for file ($BASHDIR/func/*.sh); do
        source $file
    done
    for file ($DIR/func/*.zsh); do
        source $file
    done
    for file ($DIR/lib/*.zsh); do
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
    source "$DIR/prompt.zsh"

    # Load zsh-syntax-highlighting.
    source $DIR/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

    # Load zsh-autosuggestions.
    source $DIR/bundle/autosuggestions/autosuggestions.zsh

    # Enable autosuggestions automatically.
    zle-line-init() {
        zle autosuggest-start
    }
    zle -N zle-line-init

    AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1
    AUTOSUGGESTION_HIGHLIGHT_CURSOR=1
    if [[ $(echotc Co) -gt 8 ]];then
        AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=238"
    else
        AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=5"
    fi
}

loadZsh
