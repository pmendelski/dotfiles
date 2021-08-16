#!/usr/bin/env bash -x

function __flexiPromptTerminalTitle() {
  if [ "$__FLEXI_PROMPT_TIMER" = "1" ]; then
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
  fi
}

function __flexiPromptIncrementCmdCounter() {
  : ${__FLEXI_PROMPT_CMD_COUNTER:=0}
  ((++__FLEXI_PROMPT_CMD_COUNTER))
}

function __flexiPromptHandleTimer() {
  local -r exit="$1"
  unset __FLEXI_PROMPT_TIMER_DIFF
  [ ! $__FLEXI_PROMPT_TIMER_START ] && return
  __FLEXI_PROMPT_TIMER_DIFF=$(($(epoch) - $__FLEXI_PROMPT_TIMER_START))
  unset __FLEXI_PROMPT_TIMER_START
  if [ $__FLEXI_PROMPT_NOTIFY != 0 ] && [ $__FLEXI_PROMPT_NOTIFY -lt 0 ] || [ $__FLEXI_PROMPT_TIMER_DIFF -gt $(($__FLEXI_PROMPT_NOTIFY)) ]; then
    local -r message="Time: $(formatMsMin $__FLEXI_PROMPT_TIMER_DIFF)"
    notifyLastCmd "$message"
  fi
  return $exit
}

function __flexiPromptStartTimer() {
  __FLEXI_PROMPT_TIMER_START=${__FLEXI_PROMPT_TIMER_START:-$(epoch)}
  if [ -z "$__FLEXI_PROMPT_TIMER_DIFF" ]; then
    unset __FLEXI_PROMPT_TIMER_DIFF
  fi
}

function __flexiPromptPreCmd() {
  local exit=$?
  __flexiPromptTerminalTitle
  __flexiPromptIncrementCmdCounter
  __flexiPromptHandleTimer $exit
  return $exit
}

function __flexiPromptPreExec {
  local command="${2:-unknown}"
  if [ "$command" != "__flexiPromptPreCmd" ]; then
    __flexiPromptTerminalTitle ${command}
  fi
  __flexiPromptStartTimer
}

if [ -n "$BASH_VERSION" ]; then
  # Setup handlers
  trap '__flexiPromptPreExec $BASH_COMMAND $BASH_COMMAND' DEBUG
  export PROMPT_COMMAND="__flexiPromptPreCmd; $__FLEXI_PROMPT_COMMAND"
fi
