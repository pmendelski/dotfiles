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

export FLEXI_PROMPT_DIR="$BASH_DIR/prompts/flexi"
source "$FLEXI_PROMPT_DIR/switches.sh"

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
  local mode="$__FLEXI_PROMPT_PWD_MODE"
  local prefix="$__FLEXI_PROMPT_PWD_BEFORE"
  local suffix="$__FLEXI_PROMPT_PWD_AFTER"
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

function __flexiPromptUserAtHostText() {
  local exit=$?
  local user="$USER"
  local host="${HOSTNAME:-$HOST}"
  local isRoot=$(__flexiPromptIsRoot && echo 1 || echo 0)
  local userhost="$user@$host"

  if [ -z "$SSH_CONNECTION" ]; then
    [ "$user" = "${PROMPT_DEFAULT_USERHOST%%@*}" ] && user=""
    [ "$host" = "${PROMPT_DEFAULT_USERHOST##*@}" ] && host="" || host="@$host"
    userhost="$user$host"
  fi

  # Only show username@host in special cases
  [ -z "$userhost" ] || [ "$userhost" = "$PROMPT_DEFAULT_USERHOST" ] && \
    [ -z "$SSH_CONNECTION" ] && \
    [ ! "$SUDO_USER" ] && \
    [ "$isRoot" = 0 ] && \
    return $exit;

  echo -ne "$userhost"
  return $exit
}

function __flexiPromptUserAtHost() {
  local exit=$?
  local prefix="$__FLEXI_PROMPT_USERHOST_BEFORE"
  local suffix="$__FLEXI_PROMPT_USERHOST_AFTER"
  local userAtHost="$(__flexiPromptUserAtHostText)"
  local isRoot=$(__flexiPromptIsRoot && echo 1 || echo 0)

  if [ "$isRoot" = 1 ]; then
    prefix="$__FLEXI_PROMPT_USERHOST_ROOT_BEFORE"
    suffix="$__FLEXI_PROMPT_USERHOST_ROOT_AFTER"
  fi

  if [ -n "$SSH_CONNECTION" ] && [ -n "$__FLEXI_PROMPT_SSH_INDICATOR" ]; then
    prefix="$__FLEXI_PROMPT_SSH_INDICATOR$prefix"
  fi

  if [ -n "$userAtHost" ]; then
    echo -ne "$prefix$userAtHost$suffix"
  fi
  return $exit
}

function __flexiPromptDebianChroot() {
  local exit=$?
  local chroot=""
  local prefix="$__FLEXI_PROMPT_CHROOT_BEFORE"
  local suffix="$__FLEXI_PROMPT_CHROOT_AFTER"
  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    chroot="$prefix$(cat /etc/debian_chroot)$suffix"
  fi
  echo -ne $chroot
  return $exit
}

function __flexiPromptGitStatus() {
  local exit=$?
  local prefix="$__FLEXI_PROMPT_GIT_BEFORE"
  local suffix="$__FLEXI_PROMPT_GIT_AFTER"

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
  local format="$__FLEXI_PROMPT_TIMESTAMP"
  local prefix="$__FLEXI_PROMPT_TIMESTAMP_BEFORE"
  local suffix="$__FLEXI_PROMPT_TIMESTAMP_AFTER"
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
  local treshold=$__FLEXI_PROMPT_TIMER
  local prefix="$__FLEXI_PROMPT_TIMER_BEFORE"
  local suffix="$__FLEXI_PROMPT_TIMER_AFTER"
  [ ! $__FLEXI_PROMPT_TIMER_DIFF ] || [ "$__FLEXI_PROMPT_TIMER_DIFF" -lt "0" ] && \
    return $exit
  [ $treshold -lt 0 ] || [ $__FLEXI_PROMPT_TIMER_DIFF -gt "$treshold" ] && \
    echo -ne "$prefix$(formatMsMin $__FLEXI_PROMPT_TIMER_DIFF)$suffix"
  return $exit
}

function __flexiPromptShlvl() {
  local exit=$?
  local treshold=$__FLEXI_PROMPT_SHLVL
  local prefix="$__FLEXI_PROMPT_SHLVL_BEFORE"
  local suffix="$__FLEXI_PROMPT_SHLVL_AFTER"
  [ $treshold -lt 0 ] || [ $SHLVL -gt $treshold ] && \
    [[ ! $TERM =~ ^screen ]] && \
    echo -ne "$prefix$SHLVL$suffix"
  return $exit
}

function __flexiPromptNewLinePreCmd() {
  local exit=$?
  local counter=${__FLEXI_PROMPT_CMD_COUNTER:-2}
  [ $counter != 1 ] && echo -e "\n$(__flexiPromptUnprintable $COLOR_RESET)"
  return $exit
}

function __flexiPromptNewLine() {
  local exit=$?
  local userAtHost="$(__flexiPromptUserAtHostText)"
  case "$__FLEXI_PROMPT_NEWLINE" in
    2)
      [ "$PWD" != "$HOME" ] || [ -n "$userAtHost" ] && echo -e "\n$(__flexiPromptUnprintable $COLOR_RESET)"
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
    [ -n "$__FLEXI_PROMPT_NEWLINE_PRECMD" ] && PS1+='$(__flexiPromptNewLinePreCmd)'
    [ -n "$__FLEXI_PROMPT_SHLVL" ] && PS1+='$(__flexiPromptShlvl)'
    [ -n "$__FLEXI_PROMPT_TIMESTAMP" ] && PS1+='$(__flexiPromptTimestamp)'
    PS1+='$(__flexiPromptDebianChroot)'
    PS1+='$(__flexiPromptUserAtHost)'
    PS1+='$(__flexiPromptPwd)'
    [ -n "$__FLEXI_PROMPT_GIT" ] && PS1+='$(__flexiPromptGitStatus)'
    [ -n "$__FLEXI_PROMPT_TIMER" ] && PS1+='$(__flexiPromptTimer)'
    [ -n "$__FLEXI_PROMPT_NEWLINE" ] && PS1+='$(__flexiPromptNewLine)'
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

  export PS1="$(buildPS1)"                                  # Prompt string
  [ $__FLEXI_PROMPT_PS2 != 0 ] && export PS2="> "           # Subshell prompt string
  [ $__FLEXI_PROMPT_PS4 != 0 ] && export PS4="$(buildPS4)"  # Debug prompt string  (when using `set -x`)

  # Make propmpt extensible
  type "__flexiRebuildPromptsExt" >/dev/null 2>&1 && __flexiRebuildPromptsExt
}

function flexiPromptTheme() {
  local -r defaultTheme="${FLEXI_PROMPT_THEME:-pure}"
  local -r theme="${1:-$defaultTheme}"
  local themeFile="$theme"
  [ ! -f "$themeFile" ] && themeFile="$FLEXI_PROMPT_DIR/themes/$theme.sh"
  if [ -f "$themeFile" ]; then
    __flexiPromptSetupDefaults
    source "$themeFile"
    __flexiRebuildPrompts
    if [ -z "$__FLEXI_PROMPT_NEXT_THEME_CHANGE" ]; then
      __FLEXI_PROMPT_NEXT_THEME_CHANGE="1"
    else
      echo "Switched to flexi prompt theme: $themeFile"
      echo "To save the flexi prompt theme set: \$FLEXI_PROMPT_THEME=\"$theme\""
    fi
  else
    echo "Could not locate flexi prompt theme: \"$theme\""
    echo "Checked locations:"
    echo "  $theme"
    echo "  $FLEXI_PROMPT_DIR/themes/$theme.sh"
  fi
}

if [ -n "$BASH_VERSION" ]; then
  # Initialize prompt
  flexiPromptTheme
fi

# Hooks must be sourced as the last one
source "$FLEXI_PROMPT_DIR/hooks.sh"

# Default PS1 - just in case of emergency ;)
# export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
