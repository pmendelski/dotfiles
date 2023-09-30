#!/bin/zsh

# Command history configuration
# http://zsh.sourceforge.net/Guide/zshguide02.html
export HISTFILE="$ZSH_TMP_DIR/.history"
export HISTSIZE=100000      # The shell will read $HISTSIZE lines from $HISTFILE at the start of an interactive session
export SAVEHIST=9000       # The shell will save the last $SAVEHIST lines you executed at the end of the session

# History options
# http://zsh.sourceforge.net/Doc/Release/Options.html#History
alias history='fc -il 1'        # Add timestamp to history "yyyy-mm-dd"
unsetopt hist_beep              # No beeping
setopt append_history           # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history         # Save timestamp of command and duration
setopt hist_expire_dups_first   # When trimming history, lose oldest duplicates first
setopt hist_ignore_dups         # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space        # Remove command line from history list when first character on the line is a space
setopt hist_find_no_dups        # When searching history don't display results already cycled through twice
# setopt hist_reduce_blanks       # Remove extra blanks from each command line being added to history (removed new lines used for cmd arguments)
setopt hist_verify              # Don't execute, just expand history
setopt inc_append_history       # Add comamnds as they are typed, don't wait until shell exit

# Wrapper function for history command.
historyc() {
  local -r ESC="$(printf '\033')"
  local -r HIST_COLOR_GREEN="${ESC}[0;32m"
  local -r HIST_COLOR_BLUE="${ESC}[0;34m"
  local -r HIST_COLOR_RESET="${ESC}[0m"
  local -r NUMBER_STYLE="${HIST_COLOR_GREEN}"
  local -r TIME_STYLE="${HIST_COLOR_BLUE}"
  history "$@" | sed \
    -e "s/\(^ *[^ ]\+\)  \([^ ]\+ [^ ]\+\)  \([^ ]\+\)/${NUMBER_STYLE}\1  ${TIME_STYLE}\2  ${HIST_COLOR_RESET}\3/g"
  return ${PIPESTATUS[0]}
}

alias h='historyc'
alias hs='historyc | grep -i --color'
