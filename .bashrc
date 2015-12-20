#!/bin/bash
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

# Load other dotfiles
for file in ~/.bash_{prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
    [ -r "${file}_local" ] && source "${file}_local"
done
unset file
# Added Scripts and .bin folder too look for executable bash scripts
# Scripts folder is for user custom scipts
# .bin is used in .bash_aliases
export PATH="$PATH:$HOME/.bin:$HOME/Scripts"

# Bash History
HISTTIMEFORMAT='%FT%T  '     # timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
HISTCONTROL=ignoreboth       # don't put duplicate lines or lines starting with space in the history.
HISTSIZE=100000              # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=$((2 * HISTSIZE))
shopt -s histappend          # append to the history file, don't overwrite it
# Save and reload the history after each command finishes
# The only downside with this is on the readline will go over all history not just this bash session.
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Better `cd`
shopt -s nocaseglob          # Case-insensitive globbing (used in pathname expansion)
shopt -s cdspell             # Autocorrect typos in path names when using `cd`

# Better `ssh`
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# check the window size after each command and, if necessary,
shopt -s checkwinsize # update the values of LINES and COLUMNS.

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features
# for example it's needed to autocomplete git commands
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Added by RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Added by NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
