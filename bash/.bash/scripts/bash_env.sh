#!/usr/bin/env bash
# Sourced by bash for every non-interactive shell (via $BASH_ENV).
# Sets a bash-native PS4 so `bash -x` produces readable xtrace output.
#
# Colors match the zsh PS4: gray=timestamp/()', blue=file, cyan=line, magenta=func.
# \e in bash prompt strings decodes to ESC; \011 is tab; \D{} is strftime.
#
# Both { } blocks redirect FD 2 to /dev/null. Since BASH_XTRACEFD defaults
# to FD 2, all trace output inside the blocks is silently discarded.
{ [[ $- == *x* ]] && _benv_x=1; set +x; } 2>/dev/null
PS4='+ \e[1;90m\D{%H:%M:%S} \e[1;34m${BASH_SOURCE[0]/#$HOME/~}\e[0m:\e[1;36m${LINENO}\e[0m\011${FUNCNAME[0]:+\e[0;35m${FUNCNAME[0]}\e[1;90m()\e[0m:\011}'
{ [[ ${_benv_x-} == 1 ]] && set -x; unset _benv_x; } 2>/dev/null
