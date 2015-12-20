#!/bin/bash

# Become a root and preserve environment variables and shell
alias root="sudo su --preserve-environment"

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd..="cd .."
alias ~="cd ~"
alias -- -="cd -"

# Better ls
alias ls="ls -aFh --color --group-directories-first"
alias lld='ls -la --group-directories-first | grep --color="never" "^d"'
alias llf='ls -la --group-directories-first | grep --color="never" "^[^d]"'
alias ll='ls -alF --group-directories-first --color'
alias la='ls -A --group-directories-first --color'
alias l='ls -CF --group-directories-first --color'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Easy access to hosts file
alias hosts="sudo $EDITOR /etc/hosts"

# IP addresses
alias localwlanip="ifconfig wlan0 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias localethip="ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias localips="ifconfig  | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Shortcuts
alias g="git"
alias v="vim"
alias editor="$EDITOR"
alias e="$EDITOR"

# Colorized replacements
alias mvn="mvn-color"

# Simplified HTTP methods
if [ -x "$(command -v lwp-request)" ]; then
    for method in GET HEAD PATCH POST PUT DELETE TRACE OPTIONS; do
        alias "$method"="lwp-request -m '$method'"
    done
elif [ -x "$(command -v curl)" ]; then
    for method in GET HEAD PATCH POST PUT DELETE TRACE OPTIONS; do
        alias "$method"="curl -X '$method'"
    done
fi

# Copy to clipboard. Use like:
#   cat file | clipboard
if [ -x "$(command -v xclip)" ]; then
    alias clipboard="xclip -selection clip"
fi

# Alert notification for long running commands. Use like so:
#   sleep 10; notify
if [ -x "$(command -v notify-send)" ]; then
    alias notify='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
