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
    local mode=${1-$__PROMPT_PWD_MODE}
    local prefix=${2-$__PROMPT_PWD_BEFORE}
    local suffix=${3-$__PROMPT_PWD_AFTER}
    if [ $PWD = $HOME ]; then
        echo -e "${prefix}~${suffix}"
        return $exit
    fi
    if [ $PWD = "/" ]; then
        echo -e "$prefix/$suffix"
        return $exit
    fi
    local result=""
    local homeShort="~"
    if [ $mode = 1 ]; then
        # First letters: ~/D/n/project
        result="$(dirname $PWD | sed -re "s|/$||;s|$HOME|~|;s|/(.)[^/]*|/\1|g")/$(basename $PWD)"
    elif [ $mode = 2 ]; then
        # First letters with dots: .../D/n/project
        result="$(dirname $PWD | sed -re "s|/$||;s|$HOME|~|;s|/(.)[^/]*|/\1|g")/$(basename $PWD)"
        result="$(echo $result | sed -re "s|((/[^/]+){3,})((/[^/]+){3})$|...\3|")"
    else
        result="${PWD/#$HOME/$homeShort}"
    fi
    echo -e "$prefix$result$suffix"
    return $exit
}

function __promptUserAtHost() {
    local exit=$?
    local prefix=${1-$__PROMPT_USERHOST_BEFORE}
    local suffix=${2-$__PROMPT_USERHOST_AFTER}
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

    echo -e "$prefix$userhost$suffix"
    return $exit
}

function __promptDebianChroot() {
    local exit=$?
    local chroot=""
    local prefix=${1-$__PROMPT_CHROOT_BEFORE}
    local suffix=${2-$__PROMPT_CHROOT_AFTER}
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        chroot="$prefix$(cat /etc/debian_chroot)$suffix"
    fi
    echo -e $chroot
    return $exit
}

function __promptGitStatus() {
    local exit=$?
    local prefix=${2-$__PROMPT_GIT_BEFORE}
    local suffix=${3-$__PROMPT_GIT_AFTER}

    # branch status
    local branchStatus="$(git_branch_status)"
    [ -z "$branchStatus" ] && return $exit # no git repository

    # dirty status
    local dirtyStatus=""
    git_has_staged_changes && dirtyStatus+="$__PROMPT_GIT_STAGED_CHANGES"
    git_has_unstaged_changes && dirtyStatus+="$__PROMPT_GIT_UNSTAGED_CHANGES"
    git_has_untracked_files && dirtyStatus+="$__PROMPT_GIT_UNTRACKED_FILES"

    # stash status
    local stashStatus="$(git_stash_size)"
    [ ! -z "$stashStatus" ] && [ "$stashStatus" -gt 0 ] &&
        stashStatus="$stashStatus" ||
        stashStatus=""

    # upstream status
    local upstreamStatus="$(git_upstream_status)"
    [ "$upstreamStatus" = "=" ] && upstreamStatus=""

    # dirty markers
    local markers=""
    [ -z "${dirtyStatus}" ] || markers+="${dirtyStatus}"
    [ -z "${stashStatus}" ] || markers+=" s${stashStatus}"
    [ -z "${upstreamStatus}" ] || markers+=" u${upstreamStatus}"

    echo -e "$prefix${branchStatus}${markers}$suffix"
    return $exit
}

function __promptTimestamp() {
    local exit=$?
    local format=${1-$__PROMPT_TIMESTAMP}
    local prefix=${2-$__PROMPT_TIMESTAMP_BEFORE}
    local suffix=${3-$__PROMPT_TIMESTAMP_AFTER}
    local ts=""
    if [ "$format" = "0" ]; then
        ts=""
    elif [ "$format" = "1" ]; then
        ts="$(date +"%T.%3N")"
    elif [ "$format" = "2" ]; then
        ts="$(date +"%T")"
    elif [ "$format" = "3" ]; then
        ts="$(date +"%F %T")"
    elif [ "$format" = "4" ]; then
        ts="$(date +"%F %T.%3N")"
    elif [ ! -z "$format" ]; then
        ts="$(date +"$format")"
    fi

    [ -z "$ts" ] || echo -e "$prefix$ts$suffix"
    return $exit;
}

function __promptTimer() {
    local exit=$?
    local treshold=${1-$__PROMPT_TIMER}
    local prefix=${2-$__PROMPT_TIMER_BEFORE}
    local suffix=${3-$__PROMPT_TIMER_AFTER}
    [ ! $__PROMPT_TIMER_DIFF ] || [ "$__PROMPT_TIMER_DIFF" -lt "0" ] && return $exit
    [ $treshold -lt 0 ] || [ $__PROMPT_TIMER_DIFF -gt "$treshold" ] && \
        echo -e "$prefix$(epochDiffMin $__PROMPT_TIMER_DIFF)$suffix"
    return $exit
}

function __promptShlvl() {
    local exit=$?
    local treshold=${1-$__PROMPT_SHLVL}
    local prefix=${2-$__PROMPT_SHLVL_BEFORE}
    local suffix=${3-$__PROMPT_SHLVL_AFTER}
    [ $treshold -lt 0 ] || [ $SHLVL -gt $treshold ] && \
        echo -e "$prefix$SHLVL$suffix"
    return $exit
}

function unprintable() {
    [ -z $1 ] && return
    echo -e "$__PROMPT_UNPRINTABLE_PREFIX$1$__PROMPT_UNPRINTABLE_SUFFIX"
}

function rebuildPrompts() {

    function terminalTitle() {
        case "$TERM" in
            xterm*|rxvt*)
                local title=""
                title+="\$(__promptDebianChroot '' '')"
                title+="\$(__promptUserAtHost '' ':')"
                title+="\$(__promptPwd 1 '' '')"
                title="${__PROMPT_TITLE_PREFIX}$title${__PROMPT_TITLE_SUFFIX}"
                echo "$title"
                ;;
            *)
                echo ""
                ;;
        esac
    }

    function echotest() {
        echo -e "$COLOR_BLUE xxx"
    }

    function buildPS1() {
        if [ $__PROMPT_SIMPLE -eq 1 ]; then
            if [ ! $__PROMPT_COLORS -eq 0 ]; then
                echo "$__PROMPT_BASIC"
            else
                echo "$__PROMPT_BASIC_NO_COLORS"
            fi
            return;
        fi
        local PS1=""
        local NL="\n"
        PS1+="$(terminalTitle)"
        [ $__PROMPT_NEWLINE_PRECMD != 0 ] && PS1+="\$(declare cmdstatus=\$?; [ \$__PROMPT_CMD_COUNTER != 1 ] && echo \"$NL\"; exit \$cmdstatus)"
        [ $__PROMPT_SHLVL != 0 ] && PS1+="\$(__promptShlvl)"
        [ $__PROMPT_TIMESTAMP != 0 ] && PS1+="\$(__promptTimestamp)"
        PS1+="\$(__promptDebianChroot)"
        PS1+="\$(__promptUserAtHost)"
        PS1+="\$(__promptPwd)"
        [ $__PROMPT_GIT != 0 ] && PS1+="\$(__promptGitStatus)"
        [ $__PROMPT_TIMER != 0 ] && PS1+="\$(__promptTimer)"
        [ $__PROMPT_NEWLINE != 0 ] && PS1+="\n"
        PS1+="\$(declare cmdstatus=\${?:-0}; [ \$cmdstatus != 0 ] && echo \"$__PROMPT_CMD_ERROR\" || echo \"$__PROMPT_CMD_SUCCESS\"; exit \$cmdstatus)"
        echo "$PS1"
    }

    function buildPS4() {
        if [ $__PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $__PROMPT_COLORS != 0 ]; then
            local gray="$(unprintable $COLOR_GRAY_INT_BOLD)"
            local blue="$(unprintable $COLOR_BLUE_BOLD)"
            local reset="$(unprintable $COLOR_RESET)"
            local cyan="$(unprintable $COLOR_CYAN_BOLD)"
            local magenta="$(unprintable $COLOR_MAGENTA)"
        fi
        local tab="\011"
        local PS4="+ ";
        PS4+="$gray\D{%H:%M:%S} "
        PS4+="$blue\${BASH_SOURCE/#\$HOME/\~}$reset:$cyan\${LINENO}"
        PS4+="$reset$tab\${FUNCNAME[0]:+$magenta\${FUNCNAME[0]}$gray()$reset:$tab }"
        PS4+="$reset"
        echo "$PS4";
    }

    export PS1="$(buildPS1)"                            # Prompt string
    [ $__PROMPT_PS2 != 0 ] && export PS2="> "           # Subshell prompt string
    [ $__PROMPT_PS4 != 0 ] && export PS4="$(buildPS4)"  # Debug prompt string  (when using `set -x`)

    # Make it extensible
    type "rebuildPrompts2" >/dev/null 2>&1 && rebuildPrompts2
}

function __promptPreCmd() {
    local exit=$?
    # Command counter
    : ${__PROMPT_CMD_COUNTER:=0}
    ((__PROMPT_CMD_COUNTER++))
    # Timer mechanism
    unset __PROMPT_TIMER_DIFF
    [ ! $__PROMPT_TIMER_START ] && return $exit
    __PROMPT_TIMER_DIFF=$(($(epoch) - $__PROMPT_TIMER_START))
    unset __PROMPT_TIMER_START
    [ $__PROMPT_NOTIFY -lt 0 ] || [ $__PROMPT_TIMER_DIFF -gt $(($__PROMPT_NOTIFY)) ] && {
        [ $exit = 0 ] # Reassign ?
        notify "Time: $(epochDiffMin $__PROMPT_TIMER_DIFF)"
    }
    return $exit
}

function __promptPreExec {
    local exit=$?
    # Timer mechanism
    # http://stackoverflow.com/questions/1862510/how-can-the-last-commands-wall-time-be-put-in-the-bash-prompt
    __PROMPT_TIMER_START=${__PROMPT_TIMER_START:-$(epoch)}
    [ $__PROMPT_TIMER_DIFF ] && unset __PROMPT_TIMER_DIFF
    return $exit
}

function __prompt_define_opt() {
    local funcname=$1
    local varname=$2
    local default=$3
    # Setup default value
    eval $varname=\${$varname-$default}
    # Setup toggle function
    eval "$(echo "
    function $funcname() {
        local a=\$(echo "\$1" | tr '[:lower:]' '[:upper:]')
        # Make it extensible
        type \"rebuildPrompts2\" >/dev/null 2>&1 && rebuildPrompts2
        if [ -z \$a ]; then
            [ \$$varname = 0 ] && $varname=1 || $varname=0;
        elif [ "\$a" = "TRUE" ] || [ "\$a" = "T" ] || [ "\$a" = "1" ]; then
            $varname=1
        elif [ "\$a" = "FALSE" ] || [ "\$a" = "F" ] || [ "\$a" = "0" ]; then
            $varname=0
        else
            $varname=\$1
        fi
        echo \"$varname=\$$varname\"
        rebuildPrompts
    }")"
}

################################################################################
# Basic prompts
################################################################################
: ${__PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD\u@\h$COLOR_RESET:$COLOR_BLUE_BOLD\w$COLOR_RESET\$ "}
: ${__PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "}
# Use colors
__prompt_define_opt prompt_colors __PROMPT_COLORS 1
# Fallback to simple prompt
__prompt_define_opt prompt_simple __PROMPT_SIMPLE 0

################################################################################
# Globals
################################################################################
: ${__PROMPT_PS2:=1}
: ${__PROMPT_PS4:=1}
: ${__PROMPT_UNPRINTABLE_PREFIX:="\x01"}
: ${__PROMPT_UNPRINTABLE_SUFFIX:="\x02"}
: ${__PROMPT_TITLE_PREFIX:="\[\e]0;"}
: ${__PROMPT_TITLE_SUFFIX:="\007\]"}

################################################################################
# Line feeds
################################################################################
# Break command line after prompt
__prompt_define_opt prompt_newline __PROMPT_NEWLINE 0
# Break command line before prompt
__prompt_define_opt prompt_newline_precmd __PROMPT_NEWLINE_PRECMD 0

################################################################################
# PWD
################################################################################
: ${__PROMPT_PWD_BEFORE:="$(unprintable $COLOR_BLUE_BOLD)"}
: ${__PROMPT_PWD_AFTER:="$(unprintable $COLOR_RESET)"}
# Setup pwd mode (0-"~/Desktop/Project", 1-"~/a/b/c/project", 2-".../x/y/z/project")
__prompt_define_opt prompt_pwd_mode __PROMPT_PWD_MODE 2

################################################################################
# Shell level
################################################################################
: ${__PROMPT_SHLVL_BEFORE:="$(unprintable $COLOR_YELLOW_BOLD)"}
: ${__PROMPT_SHLVL_AFTER:="$(unprintable $COLOR_RESET)\\"}
# Show subshell count from SHLVL (-1=all, 0=never, x>0=mesure those above x sublevels)
__prompt_define_opt prompt_shlvl __PROMPT_SHLVL 1

################################################################################
# GIT
################################################################################
: ${__PROMPT_GIT_BEFORE:="$(unprintable $COLOR_MAGENTA_BOLD)("}
: ${__PROMPT_GIT_AFTER:=")$(unprintable $COLOR_RESET)"}
: ${__PROMPT_GIT_STAGED_CHANGES:="+"}
: ${__PROMPT_GIT_UNSTAGED_CHANGES:="*"}
: ${__PROMPT_GIT_UNTRACKED_FILES:="%"}
# Show GIT status
__prompt_define_opt prompt_git __PROMPT_GIT $(hash git 2>/dev/null && echo 1)

################################################################################
# Timer
################################################################################
: ${__PROMPT_TIMER_BEFORE:="$(unprintable $COLOR_GRAY)["}
: ${__PROMPT_TIMER_AFTER:="]$(unprintable $COLOR_RESET)"}
# Long running cmd notification (-1=all, 0=never, x>0=mesure those above x ms)
__prompt_define_opt prompt_notify __PROMPT_NOTIFY 5000
# Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__prompt_define_opt prompt_timer __PROMPT_TIMER 5000

################################################################################
# Timestamp
################################################################################
: ${__PROMPT_TIMESTAMP_BEFORE:="$(unprintable $COLOR_GRAY)["}
: ${__PROMPT_TIMESTAMP_AFTER:="]$(unprintable $COLOR_RESET)"}
# Add timestamp to prompt (date format)
__prompt_define_opt prompt_timestamp __PROMPT_TIMESTAMP 0

################################################################################
# CMD sign
################################################################################
: ${__PROMPT_CMD_ERROR:="$(unprintable $COLOR_RED_BOLD)\$$(unprintable $COLOR_RESET) "}
: ${__PROMPT_CMD_SUCCESS:="$(unprintable $COLOR_MAGENTA)\$$(unprintable $COLOR_RESET) "}

################################################################################
# User and host
################################################################################
: ${__PROMPT_USERHOST_BEFORE:="$(unprintable $COLOR_GREEN_BOLD)"}
: ${__PROMPT_USERHOST_AFTER:=":$(unprintable $COLOR_RESET)"}
: ${__PROMPT_USERHOST_ROOT_BEFORE:="$(unprintable $COLOR_RED_BOLD)"}
: ${__PROMPT_USERHOST_ROOT_AFTER:=":$(unprintable $COLOR_RESET)"}
# Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
__prompt_define_opt prompt_default_userhost PROMPT_DEFAULT_USERHOST ""

################################################################################
# chroot
################################################################################
: ${__PROMPT_CHROOT_BEFORE:="$(unprintable $COLOR_GREEN_BOLD)("}
: ${__PROMPT_CHROOT_AFTER:=")$(unprintable $COLOR_RESET)"}

: ${PROMPT_THEME:=$1}
[ -n "$PROMPT_THEME" ] \
    && [ -r "$BASH_DIR/prompts/themes/$PROMPT_THEME.sh" ] \
    && source "$BASH_DIR/prompts/themes/$PROMPT_THEME.sh"

if [ -n "$BASH_VERSION" ]; then
    # Initial prompt build
    rebuildPrompts
    # Timer mechanism
    trap '__promptPreExec' DEBUG
    export PROMPT_COMMAND="__promptPreCmd; $__PROMPT_COMMAND"
fi

# Default PS1 - just in case of emergency ;)
# export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
