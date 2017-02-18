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
alias lld='ls -lha --group-directories-first | grep --color="never" "^d"'
alias llf='ls -lha --group-directories-first | grep --color="never" "^[^d]"'
alias ll='LC_COLLATE=C ls -alhF --group-directories-first --color'
alias la='ls -A --group-directories-first --color'
alias l='ls -CF --group-directories-first --color'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Easy access to hosts file
alias hosts="sudo $EDITOR /etc/hosts"

# IP addresses
alias ip_local_wlan="ifconfig wlan0 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias ip_local_eth="ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias ip_local_all="ifconfig  | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1"
alias ip_resolve="dig +short myip.opendns.com @resolver1.opendns.com"

# Editor
alias v="vim"
alias editor="$EDITOR"
alias e="$EDITOR"

# Shortcuts
alias g="git"
alias git-cd="cd \$(git rev-parse --show-toplevel)"
alias gcd="cd \$(git rev-parse --show-toplevel)"

# Tmux
alias ta='tmux attach'
alias tls='tmux ls'

# File/Directory Sizes
alias ducks='du -cksh * | sort -hr'
alias ducks15='du -cksh * | sort -hr | head -n 15'

# ASCII
alias dailyepigram="fortune -as | cowsay -f \$(ls /usr/share/cowsay/cows/ | shuf -n1)"
alias asciitext="figlet -f slant"

# HELP
alias dotfiles-git-doc="sensible-browser 'https://github.com/mendlik/dotfiles/blob/master/git/readme.md'"
alias dotfiles-git-edit="editor ~/.dotfiles/git"
alias dotfiles-tmux-doc="sensible-browser 'https://github.com/mendlik/dotfiles/blob/master/tmux/readme.md'"
alias dotfiles-tmux-edit="editor ~/.dotfiles/tmux"
alias dotfiles-bash-doc="sensible-browser 'https://github.com/mendlik/dotfiles/blob/master/bash/readme.md'"
alias dotfiles-bash-edit="editor ~/.dotfiles/bash"
alias dotfiles-zsh-doc="sensible-browser 'https://github.com/mendlik/dotfiles/blob/master/zsh/readme.md'"
alias dotfiles-zsh-edit="editor ~/.dotfiles/zsh"
alias dotfiles-vim-doc="sensible-browser 'https://github.com/mendlik/dotfiles/blob/master/vim/readme.md'"
alias dotfiles-vim-edit="editor ~/.dotfiles/vim"

# Simplified HTTP methods
if [ -x "$(command -v httpie)" ]; then
    for method in GET HEAD PATCH POST PUT DELETE TRACE OPTIONS; do
        alias "$method"="http $method"
    done
elif [ -x "$(command -v curl)" ]; then
    for method in GET HEAD PATCH POST PUT DELETE TRACE OPTIONS; do
        alias "$method"="curl -X '$method'"
    done
fi

# Alert notification for long running commands. Use like so:
#   sleep 10; notify
if [ -x "$(command -v notify-send)" ]; then
    alias notify='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(\history | tail -n 1 | sed -e '\''s/^\s*[0-9]\+  \([0-9]\{4,\}-[0-9]\{2\}-[0-9]\{2\}\s\+[0-9]\{2\}\(:[0-9]\{2\}\)\{1,2\}\s\+\)\{0,1\}//;s/\s*[;&|]\s*notify\(\s\+.*\)\{0,1\}\s*$//'\'')"'
fi
