#!/bin/bash -x

# This prompt inspired by:
#   https://github.com/alrra/dotfiles/blob/master/shell/bash_prompt
#   https://github.com/paulirish/dotfiles/blob/master/.bash_prompt
#   https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

# Documentation:
#   http://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/
#   http://askubuntu.com/questions/372849/what-does-debian-chrootdebian-chroot-do-in-my-terminal-prompt
#   http://misc.flogisoft.com/bash/tip_colors_and_formatting
#   http://wiki.bash-hackers.org/scripting/terminalcodes

function __promptIsRoot() {
    [[ "${USER}" == *"root" ]] \
        && return 0 \
        || return 1
}

function __promptPwd() {
    local exit=$?
    local homeShort="~"
    echo "${PWD/#$HOME/$homeShort}"
    return $exit
}

function __promptUserAtHost() {
    local exit=$?
    local user=$USER
    local host=${HOSTNAME:-$HOST}
    local userhost

    [ "$user" = "${PROMPT_DEFAULT_USERHOST%%@*}" ] && user=""
    [ "$host" = "${PROMPT_DEFAULT_USERHOST##*@}" ] && host="" || host="@$host"
    userhost="$user$host"

    # Only show username@host in special cases
    [ -z "$userhost" ] || [ "$userhost" = "$PROMPT_DEFAULT_USERHOST" ] && \
        [ ! "$SSH_CONNECTION" ] && \
        [ ! "$SUDO_USER" ] && \
        ! __promptIsRoot && \
        return $exit;

    echo "$userhost:"
    return $exit
}

function __promptDebianChroot() {
    local exit=$?
    local chroot=""
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        chroot="($(cat /etc/debian_chroot))"
    fi
    echo $chroot
    return $exit
}

function __promptGitStatus() {
    local exit=$?
    [ $PROMPT_GIT -eq 0 ] && return $exit
    # branch status
    local branchStatus="$(git_branch_status)"
    [ -z "$branchStatus" ] && return $exit # no git repository

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

    echo "(${branchStatus}${suffix})"
    return $exit
}

function __promptTimestamp() {
    local exit=$?
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

    [ -z "$ts" ] || echo "[$ts]"
    return $exit;
}

function __promptTimer() {
    local exit=$?
    [ ! $__PROMPT_TIMER_DIFF ] || [ "$__PROMPT_TIMER_DIFF" -lt "0" ] && return $exit
    [ $PROMPT_TIMER -lt 0 ] || [ $__PROMPT_TIMER_DIFF -gt "$PROMPT_TIMER" ] && \
        echo "[$(epochDiffMin $__PROMPT_TIMER_DIFF)]"
    return $exit
}

function __promptBreakPs1() {
    local exit=$?
    [ -z $PROMPT_NEWLINE ] && return $exit
    [ "$PROMPT_NEWLINE" = "" ] && return $exit
    local psLength=$(stripNonPrintable "$1" | wc -c)
    if [[ "$PROMPT_NEWLINE" = *"%" ]] && hash tput 2>/dev/null; then
        local cols="$(tput cols)"
        local percent=${PROMPT_NEWLINE/\%/\/100}
        [ $(( $cols * $percent )) -lt $(( $psLength % $cols )) ] && echo "\n"
    elif [ $psLength -gt $PROMPT_NEWLINE ]; then
        echo "\n"
    fi
    return $exit
}

function __promptNonBreakableConcat() {
    local exit=$?
    if [ -z $PROMPT_NEWLINE ] || ! hash tput 2>/dev/null; then
        echo "$1$2"
        return $exit
    fi
    local a=$(stripNonPrintable "${1##*\\n}" | wc -c)
    local b=$(stripNonPrintable "${2%%\\n*}" | wc -c)
    local cols=$(tput cols)
    [[ $(( $a + $b )) -gt $cols ]] && \
        echo "$1\n$2" || \
        echo "$1$2"
    return $exit
}

function rebuildPrompts() {

    function unprintable() {
        [ -z $1 ] && return
        echo "$__PROMPT_UNPRINTABLE_PREFIX$1$__PROMPT_UNPRINTABLE_SUFFIX"
    }

    function terminalTitle() {
        local title=""
        title+="\$(__promptDebianChroot)"
        title+="\$(__promptUserAtHost)"
        title+="\$(__promptPwd)"
        title="$__PROMPT_TITLE_PREFIX$title$__PROMPT_TITLE_SUFFIX"
        echo "$title"
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
        PS1+="$(terminalTitle)"
        [ $PROMPT_NEWLINE != 0 ] && PS1+="\n"
        [ $PROMPT_TIMER != 0 ] && PS1+="$__PROMPT_TIMER_COLOR\$(__promptTimer)"
        [ $PROMPT_TIMESTAMP != 0 ] && PS1+="$__PROMPT_TIMESTAMP_COLOR\$(__promptTimestamp)"
        [ $PROMPT_COLORS != 0 ] && PS1+="\$(__promptIsRoot && echo \"$__PROMPT_ROOT_COLOR\" || echo \"$__PROMPT_USERHOST_COLOR\")"
        PS1+="\$(__promptDebianChroot)"
        PS1+="\$(__promptUserAtHost)"
        PS1+="$__PROMPT_PWD_COLOR\$(__promptPwd)"
        [ $PROMPT_GIT != 0 ] && PS1+="$__PROMPT_REPO_COLOR\$(__promptGitStatus)"
        [ $PROMPT_STATUS != 0 ] && PS1+="\$([ \$? != 0 ] && echo \"$__PROMPT_CMD_ERR_COLOR\" ||  echo \"$__PROMPT_COLOR_RESET\")"
        [ $PROMPT_NEWLINE != 0 ] && PS1+="\n"
        PS1+="\$$__PROMPT_COLOR_RESET "
        echo "$PS1";
    }

    function buildPS4() {
        if [ $PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $PROMPT_COLORS != 0 ]; then
            local gray=$(unprintable $PR_GRAY_INT_BOLD)
            local blue=$(unprintable $PR_BLUE_BOLD)
            local reset=$(unprintable $PR_RESET)
            local cyan=$(unprintable $PR_CYAN_BOLD)
            local magenta=$(unprintable $PR_MAGENTA)
        fi
        local tab="\011"
        local PS4="+ ";
        PS4+="$gray\$(date +"%T.%3N") "
        PS4+="$blue\${BASH_SOURCE/#\$HOME/\~}$reset:$cyan\${LINENO}"
        PS4+="$reset$tab\${FUNCNAME[0]:+$magenta\${FUNCNAME[0]}$gray()$reset:$tab }"
        PS4+="$reset"
        echo "$PS4";
    }

    if [ $PROMPT_COLORS -gt 0 ]; then
        __PROMPT_PWD_COLOR=$(unprintable $PR_BLUE_BOLD)
        __PROMPT_ROOT_COLOR=$(unprintable $PR_RED_BOLD)
        __PROMPT_USERHOST_COLOR=$(unprintable $PR_GREEN_BOLD)
        __PROMPT_REPO_COLOR=$(unprintable $PR_MAGENTA_BOLD)
        __PROMPT_TIMESTAMP_COLOR=$(unprintable $PR_GRAY_INT_BOLD)
        __PROMPT_TIMER_COLOR=$(unprintable $PR_GRAY_INT_BOLD)
        __PROMPT_CMD_ERR_COLOR=$(unprintable $PR_RED_BOLD)
        __PROMPT_COLOR_RESET=$(unprintable $PR_RESET)
    else
        unset __PROMPT_PWD_COLOR
        unset __PROMPT_ROOT_COLOR
        unset __PROMPT_USERHOST_COLOR
        unset __PROMPT_REPO_COLOR
        unset __PROMPT_TIMESTAMP_COLOR
        unset __PROMPT_TIMER_COLOR
        unset __PROMPT_CMD_ERR_COLOR
        unset __PROMPT_COLOR_RESET
    fi

    export PS1="$(buildPS1)"    # Prompt string
    export PS2="> "             # Subshell prompt string
    export PS4="$(buildPS4)"    # Debug prompt string  (when using `set -x`)
}

function promptStopTimer() {
    local exit=$?
    unset __PROMPT_TIMER_DIFF
    [ ! $__PROMPT_TIMER_START ] && return $exit
    __PROMPT_TIMER_DIFF=$(($(epoch) - $__PROMPT_TIMER_START))
    unset __PROMPT_TIMER_START
    [ $PROMPT_NOTIFY -lt 0 ] || [ $__PROMPT_TIMER_DIFF -gt $(($PROMPT_NOTIFY)) ] && \
        notify "Time: $(epochDiffMin $__PROMPT_TIMER_DIFF)"
    return $exit
}

function promptStartTimer {
    local exit=$?
    # http://stackoverflow.com/questions/1862510/how-can-the-last-commands-wall-time-be-put-in-the-bash-prompt
    __PROMPT_TIMER_START=${__PROMPT_TIMER_START:-$(epoch)}
    [ $__PROMPT_TIMER_DIFF ] && unset __PROMPT_TIMER_DIFF
    return $exit
}

function __define_toggle_opt() {
    local funcname=$1
    local varname=$2
    local default=$3
    # Setup default value
    eval $varname=\${$varname:=$default}
    # Setup toggle function
    eval "$(echo "
    function $funcname() {
        local a=\$(echo "\$1" | tr '[:lower:]' '[:upper:]')
        if [ -z \$a ]; then
            [ \$$varname = 0 ] && $varname=1 || $varname=0;
        elif [ "\$a" == "TRUE" ] || [ "\$a" == "T" ] || [ "\$a" == "1" ]; then
            $varname=1
        elif [ "\$a" == "FALSE" ] || [ "\$a" == "F" ] || [ "\$a" == "0" ]; then
            $varname=0
        else
            $varname=\$1
        fi
        rebuildPrompts
    }")"
}

# Prompt Config
## Fallback to simple prompt
__define_toggle_opt prompt_simple PROMPT_SIMPLE 0
## Break command line after prompt
__define_toggle_opt prompt_newline PROMPT_NEWLINE 0
## Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
__define_toggle_opt prompt_default_userhost PROMPT_DEFAULT_USERHOST ""
## Use colors
__define_toggle_opt prompt_colors PROMPT_COLORS 1
## Show GIT status
__define_toggle_opt prompt_git PROMPT_GIT $(hash git 2>/dev/null && echo 1)
## Show last command result status
__define_toggle_opt prompt_status PROMPT_STATUS 1
## Add timestamp to prompt (date format)
__define_toggle_opt prompt_timestamp PROMPT_TIMESTAMP 0
## Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__define_toggle_opt prompt_timer PROMPT_TIMER 5000
## Long running cmd notification (-1=all, 0=never, x>0=mesure those above x ms)
__define_toggle_opt prompt_notify PROMPT_NOTIFY 5000

if [ -n "$BASH_VERSION" ]; then
    # Prompt constants
    __PROMPT_UNPRINTABLE_PREFIX="\["
    __PROMPT_UNPRINTABLE_SUFFIX="\]"
    __PROMPT_TITLE_PREFIX="\[\e]0;"
    __PROMPT_TITLE_SUFFIX="\007\]"
    # Initial prompt build
    rebuildPrompts
    # Timer mechanism
    trap 'promptStartTimer' DEBUG
    export PROMPT_COMMAND="promptStopTimer; $PROMPT_COMMAND"
elif [ -n "$ZSH_VERSION" ]; then
    # Prompt constants
    __PROMPT_UNPRINTABLE_PREFIX="%{"
    __PROMPT_UNPRINTABLE_SUFFIX="%}"
    __PROMPT_TITLE_PREFIX="%{\e]0;"
    __PROMPT_TITLE_SUFFIX="\007%}"
    # Initial prompt build
    rebuildPrompts
    # Timer mechanism
    autoload -U add-zsh-hook
    add-zsh-hook preexec promptStartTimer
    add-zsh-hook precmd promptStopTimer
    # add-zsh-hook precmd promptSaveStatus
else
    echo "Unrecognized shell - prompt not installed"
fi

# Default PS1 - just in case of emergency ;)
# export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
