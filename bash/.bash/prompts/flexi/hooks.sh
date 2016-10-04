#!/bin/bash

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

if [ -n "$BASH_VERSION" ]; then
    # Setup handlers
    trap '__flexiPromptPreExec $BASH_COMMAND $BASH_COMMAND' DEBUG
    export PROMPT_COMMAND="__flexiPromptPreCmd; $__FLEXI_PROMPT_COMMAND"
fi
