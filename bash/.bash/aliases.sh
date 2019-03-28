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

# Fast clear
alias clr='clear'

# Easy access to hosts file
alias hosts="sudo $EDITOR /etc/hosts"

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

# URL
alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n} | grep . --color=never'

# Lock the screen (when going AFK)
if [[ "$OSTYPE" == darwin* ]]; then
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi

# HELP
alias dotfiles-git-doc="sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/git/readme.md' &>/dev/null"
alias dotfiles-git-edit="editor ~/.dotfiles/git"
alias dotfiles-tmux-doc="sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/tmux/readme.md' &>/dev/null"
alias dotfiles-tmux-edit="editor ~/.dotfiles/tmux"
alias dotfiles-bash-doc="sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/bash/readme.md' &>/dev/null"
alias dotfiles-bash-edit="editor ~/.dotfiles/bash"
alias dotfiles-zsh-doc="sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/zsh/readme.md' &>/dev/null"
alias dotfiles-zsh-edit="editor ~/.dotfiles/zsh"
alias dotfiles-vim-doc="sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/vim/readme.md' &>/dev/null"
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