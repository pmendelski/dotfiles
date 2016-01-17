#!/bin/bash

# This prompt inspired by:
#   https://github.com/alrra/dotfiles/blob/master/shell/bash_prompt
#   https://github.com/paulirish/dotfiles/blob/master/.bash_prompt
#   https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

# Documentation:
#   http://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/
#   http://askubuntu.com/questions/372849/what-does-debian-chrootdebian-chroot-do-in-my-terminal-prompt
#   http://misc.flogisoft.com/bash/tip_colors_and_formatting
#   http://wiki.bash-hackers.org/scripting/terminalcodes

# Config
: ${PROMPT_GIT:=$(hash git 2>/dev/null && echo 1)} # Show GIT status
: ${PROMPT_NEWLINE:=$(hash tput 2>/dev/null && echo "50%" || echo 40)} # Break command line after 40 characters (-1=never, 50%=break if gt 50% win width)
: ${PROMPT_DEFAULT_USERHOST:=""}    # Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
: ${PROMPT_TIMESTAMP:=0}            # Add timestamp to prompt (date format)
: ${PROMPT_COLORS:=1}               # Use colors
: ${PROMPT_STATUS:=1}               # Show last command result status
: ${PROMPT_SIMPLE:=0}               # Fallback to simple prompt
: ${PROMPT_TIMER:=5000}                # Time cmd execution (-1=never, 0=all, x>0=mesure those above x ms)
: ${PROMPT_NOTIFY:=5}               # Long running cmd notification (-1=never, 0=all, x>0=mesure those above x s)

function buildPrompts() {
    local -r COLOR_RESET="\[\e[0m\]"
    local -r COLOR_RED="\[\e[0;31m\]"
    local -r COLOR_RED_BOLD="\[\e[1;31m\]"
    local -r COLOR_GREEN="\[\e[0;32m\]"
    local -r COLOR_GREEN_BOLD="\[\e[1;32m\]"
    local -r COLOR_MAGENTA="\[\e[0;35m\]"
    local -r COLOR_MAGENTA_BOLD="\[\e[1;35m\]"
    local -r COLOR_CYAN_BOLD="\[\e[1;36m\]"
    local -r COLOR_BLUE_BOLD="\[\e[1;34m\]"
    local -r COLOR_GRAY_BOLD="\[\e[1;30m\]"
    local -r TAB="\011"
    local -i timerDiff

    function stripNonPrintable() {
        echo "$@" | sed -e "s/\\\\\[\([^\\\]\|\\\[^]]\)*\\\\\]//g"
    }

    function isRoot() {
        [[ "${USER}" == *"root" ]] \
            && return 0 \
            || return 1
    }

    function promptPwd() {
        echo "$COLOR_BLUE_BOLD${PWD/#$HOME/\~}"
    }

    function userAtHost() {
        local userhost="$USER@$HOSTNAME"
        # Only show username@host in special cases
        [ "$userhost" = "$PROMPT_DEFAULT_USERHOST" ] && \
            [ ! "$SSH_CONNECTION" ] && \
            [ ! "$SUDO_USER" ] && \
            ! isRoot && \
            return;

        [ isRoot ] && \
            userhost="$COLOR_RED_BOLD$userhost" || \
            userhost="$COLOR_GREEN_BOLD$userhost"

        echo $userhost;
    }

    function debianChroot() {
        local chroot=""
        if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
            chroot=$(cat /etc/debian_chroot)
            [ isRoot ] && \
                chroot="$COLOR_RED_BOLD$chroot"  || \
                chroot="$COLOR_GREEN_BOLD$chroot"
        fi
        echo $chroot
    }

    function gitStatus() {
        [ $PROMPT_GIT -eq 0 ] && return;
        # branch status
        local branchStatus="$(git_branch_status)"
        [ -z "$branchStatus" ] && return # no git repository

        # dirty status
        local dirtyStatus=""
        git_has_staged_changes && dirtyStatus+="+"
        git_has_unstaged_changes && dirtyStatus+="*"
        git_has_untracked_files && dirtyStatus+="%"

        # stash status
        local stashStatus="$(git_stash_size)"
        [ ! -z "$stashStatus" ] && [ "$stashStatus" -gt 0 ] &&
            stashStatus="$stashStatus" ||
            stashStatus=""

        # upstream status
        local upstreamStatus="$(git_upstream_status)"
        [ "$upstreamStatus" = "=" ] && upstreamStatus=""

        # suffix
        local suffix=""
        [ -z "${dirtyStatus}" ] || suffix+="${dirtyStatus}"
        [ -z "${stashStatus}" ] || suffix+=" s${stashStatus}"
        [ -z "${upstreamStatus}" ] || suffix+=" u${upstreamStatus}"

        # result
        local result="$branchStatus"
        [ -z "${suffix}" ] &&
            result="$COLOR_MAGENTA[${result}]" ||
            result="$COLOR_MAGENTA_BOLD[${result}${suffix}]"

        echo "$result"
    }

    function terminalTitle() {
        local title=""
        title+="$(debianChroot)"
        title+="$(userAtHost)"
        title+="${title:+: }"
        title+="$(promptPwd)"
        title="$(stripNonPrintable $title)"
        [ "$@" ] && title+=" $(stripNonPrintable $@)"
        title="\[\e]0;$title\007\]"
        echo "$title"
    }

    function timestamp() {
        local ts=""
        if [ "$PROMPT_TIMESTAMP" = "0" ]; then
            ts=""
        elif [ "$PROMPT_TIMESTAMP" = "1" ]; then
            ts="$(date +"%T.%3N")"
        elif [ "$PROMPT_TIMESTAMP" = "2" ]; then
            ts="$(date +"%T")"
        elif [ "$PROMPT_TIMESTAMP" = "3" ]; then
            ts="$(date +"%F %T")"
        elif [ "$PROMPT_TIMESTAMP" = "4" ]; then
            ts="$(date +"%F %T.%3N")"
        elif [ ! -z "$PROMPT_TIMESTAMP" ]; then
            ts="$(date +"$PROMPT_TIMESTAMP")"
        fi

        [ -z "$ts" ] || echo "$COLOR_GRAY_BOLD[$ts]"
    }

    function timer() {
        [ ! $timerDiff ] || [ "$PROMPT_TIMER" -lt "0" ] && return
        [ "$PROMPT_TIMER" = "0" ] || [ $timerDiff -gt "$PROMPT_TIMER" ] && \
            echo "$COLOR_GRAY_BOLD[$(epochDiffMin $timerDiff)]"
    }

    function cmdStatus() {
        [ $PROMPT_STATUS -eq 0 ] && return;
        echo "\$( \
            [ ! \$? -o \$? -eq 0 ] && \
                echo \"$COLOR_RESET\" || \
                echo \"$COLOR_RED_BOLD\";\
        )"
    }

    function breakPs1() {
        [ -z $PROMPT_NEWLINE ] && return
        [ "$PROMPT_NEWLINE" = "" ] && return
        local psLength=$(stripNonPrintable "$1" | wc -c)
        if [[ "$PROMPT_NEWLINE" = *"%" ]] && hash tput 2>/dev/null; then
            local cols="$(tput cols)"
            local percent=${PROMPT_NEWLINE/\%/\/100}
            [ $(( $cols * $percent )) -lt $(( $psLength % $cols )) ] && echo "\n"
        elif [ $psLength -gt $PROMPT_NEWLINE ]; then
            echo "\n"
        fi
    }

    function nonBreakableConcat() {
        if [ -z $PROMPT_NEWLINE ] || ! hash tput 2>/dev/null; then
            echo "$1$2"
            return
        fi
        local a=$(stripNonPrintable "${1##*\\n}" | wc -c)
        local b=$(stripNonPrintable "${2%%\\n*}" | wc -c)
        local cols=$(tput cols)
        [[ $(( $a + $b )) -gt $cols ]] && \
            echo "$1\n$2" || \
            echo "$1$2"
    }

    function buildPS1() {
        if [ $PROMPT_SIMPLE -eq 1 ]; then
            if [ ! $PROMPT_COLORS -eq 0 ]; then
                echo '${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
            else
                echo '${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
            fi
            return;
        fi
        local PS1=""
        PS1+="$(debianChroot)"
        PS1+="$(userAtHost)"
        PS1+="${PS1:+$COLOR_RESET:}"
        PS1+="$(promptPwd)"
        PS1="$(nonBreakableConcat "$PS1" "$(gitStatus)")"
        PS1+="$COLOR_RESET"
        PS1+="$(breakPs1 "$PS1")"
        PS1+="$(cmdStatus)"
        PS1+="\$$COLOR_RESET "
        PS1="$(timer)$(timestamp)$PS1"
        [ $PROMPT_COLORS -eq 0 ] && PS1="$(stripNonPrintable "$PS1")"
        PS1="$(terminalTitle)$PS1"
        echo "$PS1";
    }

    function buildPS4() {
        if [ $PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local PS4="+ ";
        PS4+="$COLOR_GRAY_BOLD\$(date +"%T.%3N") "
        PS4+="$COLOR_BLUE_BOLD\${BASH_SOURCE/#\$HOME/\~}$COLOR_RESET:$COLOR_CYAN_BOLD\${LINENO}"
        PS4+="$COLOR_RESET$TAB\${FUNCNAME[0]:+$COLOR_MAGENTA\${FUNCNAME[0]}$COLOR_GRAY_BOLD()$COLOR_RESET:$TAB }"
        PS4+="$COLOR_RESET"
        [ $PROMPT_COLORS -eq 0 ] && PS4="$(stripNonPrintable "$PS4")"
        echo "$PS4";
    }

    function stopTimer {
        timerDiff=$(($(epoch) - $PROMPT_TIMER_START))
        [ $PROMPT_NOTIFY = 0 ] || [ $timerDiff -gt $(($PROMPT_NOTIFY * 1000)) ] && \
            notify "Time: $(epochDiffMin $timerDiff)"
        unset PROMPT_TIMER_START
    }

    stopTimer
    export PS1="$(buildPS1)"    # Prompt string
    export PS2="> "             # Subshell prompt string
    export PS4="$(buildPS4)"    # Debug prompt string  (when using `set -x`)
}

function promptStartTimer {
    # http://stackoverflow.com/questions/1862510/how-can-the-last-commands-wall-time-be-put-in-the-bash-prompt
    PROMPT_TIMER_START=${PROMPT_TIMER_START:-$(epoch)}
}

trap 'promptStartTimer' DEBUG
export PROMPT_COMMAND=buildPrompts

# Default PS1 - just in case of emergency ;)
# export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
