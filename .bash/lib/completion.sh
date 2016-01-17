#!/bin/bash

# Enable programmable completion features
# It's needed to autocomplete git commands
# http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# List options alomst like in zsh
# http://superuser.com/questions/288714/bash-autocomplete-like-zsh
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
