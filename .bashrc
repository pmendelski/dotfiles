#!/bin/bash

# Default bashrc: /etc/skel/.bashrc
# ~/.bashrc: executed by bash for non-login shells.
# https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# http://serverfault.com/questions/261802/profile-vs-bash-profile-vs-bashrc

# Non-Login Shell Startup Files:
# 1. /etc/profile
# 2. ~/.bash_profile OR ~/.bash_login OR ~/.profile
# 3. ~/.bash_logout

# If not running interactively just exit
case $- in
    *i*) ;;
    *) return;;
esac

function init_bash() {
    # Load local dotfiles
    for file in ~/.bash_{prompt,exports,aliases,functions}; do
        [ -r "$file" ] && source "$file"
    done
    unset file

    # Load dotfiles
    # bash_plugins=(jvm mvn-color) # ...load them all
    source "$HOME/.bash/index.sh"

    # Scripts folder is for user custom scipts
    export PATH="$PATH:$HOME/Scripts"

    # Say hello
    shhello
}

function init_zsh() {
    exec zsh
}

# Sometimes 'chsh -s $(whish zsh)' is not an option
[ -r "~/.shell" ] && source "~/.shell"
: ${ZSH_FORCE:=0}
if [ $SHLVL -gt 1 ] && [ $ZSH_FORCE = 1 ]; then
    init_bash
else
    init_zsh
fi
