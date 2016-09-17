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

function __flexiPromptIsRoot() {
    [[ "${USER}" == *"root" ]] \
        && return 0 \
        || return 1
}

function __flexiPromptUnprintable() {
    [ -z $1 ] && return
    echo -ne "${__FLEXI_PROMPT_UNPRINTABLE_PREFIX}$1${__FLEXI_PROMPT_UNPRINTABLE_SUFFIX}"
}

function __flexiPromptPwd() {
    local exit=$?
    local mode=${1-$__FLEXI_PROMPT_PWD_MODE}
    local prefix=${2-$__FLEXI_PROMPT_PWD_BEFORE}
    local suffix=${3-$__FLEXI_PROMPT_PWD_AFTER}
    if [ $PWD = $HOME ]; then
        [ "$__FLEXI_PROMPT_PWD_SKIP_HOME" = 1 ] && return $exit
        echo -ne "${prefix}~${suffix}"
        return $exit
    fi
    if [ $PWD = "/" ]; then
        echo -ne "$prefix/$suffix"
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
    echo -ne "$prefix$result$suffix"
    return $exit
}

function __flexiPromptUserAtHost() {
    local exit=$?
    local prefix=${1-$__FLEXI_PROMPT_USERHOST_BEFORE}
    local suffix=${2-$__FLEXI_PROMPT_USERHOST_AFTER}
    local user=$USER
    local host=${HOSTNAME:-$HOST}
    local isRoot=$(__flexiPromptIsRoot && echo 1 || echo 0)
    local userhost

    if [ "$isRoot" = 1 ]; then
        local prefix=${1-$__FLEXI_PROMPT_USERHOST_ROOT_BEFORE}
        local suffix=${2-$__FLEXI_PROMPT_USERHOST_ROOT_AFTER}
    fi

    [ "$user" = "${PROMPT_DEFAULT_USERHOST%%@*}" ] && user=""
    [ "$host" = "${PROMPT_DEFAULT_USERHOST##*@}" ] && host="" || host="@$host"
    userhost="$user$host"

    # Only show username@host in special cases
    [ -z "$userhost" ] || [ "$userhost" = "$PROMPT_DEFAULT_USERHOST" ] && \
        [ ! "$SSH_CONNECTION" ] && \
        [ ! "$SUDO_USER" ] && \
        [ "$isRoot" = 0 ] && \
        return $exit;

    echo -ne "$prefix$userhost$suffix"
    return $exit
}

function __flexiPromptDebianChroot() {
    local exit=$?
    local chroot=""
    local prefix=${1-$__FLEXI_PROMPT_CHROOT_BEFORE}
    local suffix=${2-$__FLEXI_PROMPT_CHROOT_AFTER}
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        chroot="$prefix$(cat /etc/debian_chroot)$suffix"
    fi
    echo -ne $chroot
    return $exit
}

function __flexiPromptGitStatus() {
    local exit=$?
    local prefix=${2-$__FLEXI_PROMPT_GIT_BEFORE}
    local suffix=${3-$__FLEXI_PROMPT_GIT_AFTER}

    # branch status
    local branchStatus="$(git_branch_status)"
    [ -z "$branchStatus" ] && return $exit # no git repository

    # dirty status
    local dirtyStatus=""
    git_has_staged_changes && dirtyStatus+="$__FLEXI_PROMPT_GIT_STAGED_CHANGES"
    git_has_unstaged_changes && dirtyStatus+="$__FLEXI_PROMPT_GIT_UNSTAGED_CHANGES"
    git_has_untracked_files && dirtyStatus+="$__FLEXI_PROMPT_GIT_UNTRACKED_FILES"

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

    echo -ne "$prefix${branchStatus}${markers}$suffix"
    return $exit
}

function __flexiPromptTimestamp() {
    local exit=$?
    local format=${1-$__FLEXI_PROMPT_TIMESTAMP}
    local prefix=${2-$__FLEXI_PROMPT_TIMESTAMP_BEFORE}
    local suffix=${3-$__FLEXI_PROMPT_TIMESTAMP_AFTER}
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

    [ -z "$ts" ] || echo -ne "$prefix$ts$suffix"
    return $exit;
}

function __flexiPromptTimer() {
    local exit=$?
    local treshold=${1-$__FLEXI_PROMPT_TIMER}
    local prefix=${2-$__FLEXI_PROMPT_TIMER_BEFORE}
    local suffix=${3-$__FLEXI_PROMPT_TIMER_AFTER}
    [ ! $__FLEXI_PROMPT_TIMER_DIFF ] || [ "$__FLEXI_PROMPT_TIMER_DIFF" -lt "0" ] && \
        return $exit
    [ $treshold -lt 0 ] || [ $__FLEXI_PROMPT_TIMER_DIFF -gt "$treshold" ] && \
        echo -ne "$prefix$(epochDiffMin $__FLEXI_PROMPT_TIMER_DIFF)$suffix"
    return $exit
}

function __flexiPromptShlvl() {
    local exit=$?
    local treshold=${1-$__FLEXI_PROMPT_SHLVL}
    local prefix=${2-$__FLEXI_PROMPT_SHLVL_BEFORE}
    local suffix=${3-$__FLEXI_PROMPT_SHLVL_AFTER}
    [ $treshold -lt 0 ] || [ $SHLVL -gt $treshold ] && \
        [[ ! $TERM =~ ^screen ]] && \
        echo -ne "$prefix$SHLVL$suffix"
    return $exit
}

function __flexiPromptNewLinePreCmd() {
    local exit=$?
    [ $__FLEXI_PROMPT_CMD_COUNTER != 1 ] && echo -e "\n$(__flexiPromptUnprintable $COLOR_RESET)"
    return $exit
}

function __flexiPromptNewLine() {
    local exit=$?
    case "$__FLEXI_PROMPT_NEWLINE" in
        2)
            [ "$PWD" != "$HOME" ] && echo -e "\n$(__flexiPromptUnprintable $COLOR_RESET)"
            ;;
        *)
            echo -e "\n$(__flexiPromptUnprintable $COLOR_RESET)"
            ;;
    esac
    return $exit
}

function __flexiPromptSetupDefaults() {
    # Make defaults extensible
    type "__flexiPromptSetupDefaultsExt" >/dev/null 2>&1 && __flexiPromptSetupDefaultsExt
    source "$FLEXI_PROMPT_DIR/defaults.sh"
}

function __flexiRebuildPrompts() {

    function buildPS1() {
        if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
            if [ ! $__FLEXI_PROMPT_COLORS -eq 0 ]; then
                echo "$__FLEXI_PROMPT_BASIC"
            else
                echo "$__FLEXI_PROMPT_BASIC_NO_COLORS"
            fi
            return;
        fi
        local PS1=''
        [ $__FLEXI_PROMPT_NEWLINE_PRECMD != 0 ] && PS1+='$(__flexiPromptNewLinePreCmd)'
        [ $__FLEXI_PROMPT_SHLVL != 0 ] && PS1+='$(__flexiPromptShlvl)'
        [ $__FLEXI_PROMPT_TIMESTAMP != 0 ] && PS1+='$(__flexiPromptTimestamp)'
        PS1+='$(__flexiPromptDebianChroot)'
        PS1+='$(__flexiPromptUserAtHost)'
        PS1+='$(__flexiPromptPwd)'
        [ $__FLEXI_PROMPT_GIT != 0 ] && PS1+='$(__flexiPromptGitStatus)'
        [ $__FLEXI_PROMPT_TIMER != 0 ] && PS1+='$(__flexiPromptTimer)'
        [ $__FLEXI_PROMPT_NEWLINE != 0 ] && PS1+='$(__flexiPromptNewLine)'
        PS1+='$(declare cmdstatus=${?:-0}; [ $cmdstatus != 0 ] && echo "$__FLEXI_PROMPT_CMD_ERROR" || echo "$__FLEXI_PROMPT_CMD_SUCCESS"; exit $cmdstatus)'
        echo "$PS1"
    }

    function buildPS4() {
        if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $__FLEXI_PROMPT_COLORS != 0 ]; then
            local gray="$(__flexiPromptUnprintable $COLOR_GRAY_INT_BOLD)"
            local blue="$(__flexiPromptUnprintable $COLOR_BLUE_BOLD)"
            local reset="$(__flexiPromptUnprintable $COLOR_RESET)"
            local cyan="$(__flexiPromptUnprintable $COLOR_CYAN_BOLD)"
            local magenta="$(__flexiPromptUnprintable $COLOR_MAGENTA)"
        fi
        local tab="\011"
        local PS4="+ ";
        PS4+="$gray\D{%H:%M:%S} "
        PS4+="$blue\${BASH_SOURCE/#\$HOME/\~}$reset:$cyan\${LINENO}"
        PS4+="$reset$tab\${FUNCNAME[0]:+$magenta\${FUNCNAME[0]}$gray()$reset:$tab }"
        PS4+="$reset"
        echo "$PS4";
    }

    __flexiPromptSetupDefaults

    export PS1="$(buildPS1)"                                    # Prompt string
    [ $__FLEXI_PROMPT_PS2 != 0 ] && export PS2="> "             # Subshell prompt string
    [ $__FLEXI_PROMPT_PS4 != 0 ] && export PS4="$(buildPS4)"    # Debug prompt string  (when using `set -x`)

    # Make propmpt extensible
    type "__flexiRebuildPromptsExt" >/dev/null 2>&1 && __flexiRebuildPromptsExt
}

function __flexiPromptTerminalTitle() {
    case "$TERM" in
        screen*|xterm*|rxvt*)
            local title=''
            title+=$(__flexiPromptDebianChroot "" "")
            title+=$(__flexiPromptUserAtHost "" ":")
            title+=$(__flexiPromptPwd 1 "" "")
            echo -ne "${__FLEXI_PROMPT_TITLE_PREFIX}${title}${1:+ ($1)}${__FLEXI_PROMPT_TITLE_SUFFIX}"
            ;;
        *)
            echo -ne ""
            ;;
    esac
}

function __flexiPromptIncrementCmdCounter() {
    : ${__FLEXI_PROMPT_CMD_COUNTER:=0}
    ((__FLEXI_PROMPT_CMD_COUNTER++))
}

function __flexiPromptHandleTimer() {
    unset __FLEXI_PROMPT_TIMER_DIFF
    [ ! $__FLEXI_PROMPT_TIMER_START ] && return $exit
    __FLEXI_PROMPT_TIMER_DIFF=$(($(epoch) - $__FLEXI_PROMPT_TIMER_START))
    unset __FLEXI_PROMPT_TIMER_START
    [ $__FLEXI_PROMPT_NOTIFY -lt 0 ] || [ $__FLEXI_PROMPT_TIMER_DIFF -gt $(($__FLEXI_PROMPT_NOTIFY)) ] &&
        notify "Time: $(epochDiffMin $__FLEXI_PROMPT_TIMER_DIFF)"
}

function __flexiPromptStartTimer() {
    __FLEXI_PROMPT_TIMER_START=${__FLEXI_PROMPT_TIMER_START:-$(epoch)}
    [ $__FLEXI_PROMPT_TIMER_DIFF ] && unset __FLEXI_PROMPT_TIMER_DIFF
}

function __flexiPromptPreCmd() {
    __flexiPromptTerminalTitle
    __flexiPromptIncrementCmdCounter
    __flexiPromptHandleTimer
}

function __flexiPromptPreExec {
    local command="${2:-unknown}"
    [ "$command" != "__flexiPromptPreCmd" ] && __flexiPromptTerminalTitle ${command}
    __flexiPromptStartTimer
}

function __flexiPromptDefineOpt() {
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
        type \"__flexiRebuildPrompts2\" >/dev/null 2>&1 && __flexiRebuildPrompts2
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
        __flexiRebuildPromptsExt
    }")"
}

function flexiPromptTheme() {
    local -r defaultTheme="${FLEXI_PROMPT_THEME:-pure}"
    local -r theme="${1:-$defaultTheme}"
    local themeFile="$theme"
    [ ! -f "$themeFile" ] && themeFile="$FLEXI_PROMPT_DIR/themes/$theme.sh"
    if [ -f "$themeFile" ]; then
        source "$themeFile"
        __flexiRebuildPrompts
        if [ -z "$__FLEXI_PROMPT_NEXT_THEME_CHANGE" ]; then
            __FLEXI_PROMPT_NEXT_THEME_CHANGE="1"
        else
            echo "Switched to theme: $themeFile"
            echo "To save theme set: \$FLEXI_PROMPT_THEME=\"$theme\""
        fi
    else
        echo "Could not locate flexi theme: $theme"
        echo "Checked locations:"
        echo "  $theme"
        echo "  $FLEXI_PROMPT_DIR/themes/$theme.sh"
    fi
}

if [ -n "$BASH_VERSION" ]; then
    # Load theme and initial build
    flexiPromptTheme
    # Timer mechanism
    trap '__flexiPromptPreExec $BASH_COMMAND $BASH_COMMAND' DEBUG
    export PROMPT_COMMAND="__flexiPromptPreCmd; $__FLEXI_PROMPT_COMMAND"
fi

# Default PS1 - just in case of emergency ;)
# export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '