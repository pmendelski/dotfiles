#!/bin/zsh

__flexiRebuildPromptsExt() {
  buildPS4() {
    if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
      echo "+ "
      return;
    fi
    local gray blue reset cyan magenta
    if [ $__FLEXI_PROMPT_COLORS != 0 ]; then
      local gray=$COLOR_GRAY_INT_BOLD
      local blue=$COLOR_BLUE_BOLD
      local reset=$COLOR_RESET
      local cyan=$COLOR_CYAN_BOLD
      local magenta=$COLOR_MAGENTA
    fi
    local tab="\011"
    local PS4="+ ";
    PS4+="$gray%D{%H:%M:%S} "
    PS4+="$blue%x$reset:$cyan%I"
    PS4+="$reset$tab$magenta%N$gray()$reset:$tab"
    PS4+="$reset"
    echo "$PS4";
  }

  buildPS2() {
    if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
      echo "> "
      return;
    fi
    local reset cyan
    if [ $__FLEXI_PROMPT_COLORS != 0 ]; then
      local reset=$COLOR_RESET
      local cyan=$COLOR_CYAN_BOLD
    fi
    echo "$cyan(%_)>$reset ";
  }

  export PS2="$(buildPS2)"
  export PS4="$(buildPS4)"
}

__flexiPromptSetupDefaultsExt() {
  # Prompt constants
  : ${__FLEXI_PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD%n@%m$COLOR_RESET:$COLOR_BLUE_BOLD%~$COLOR_RESET\$ "}
  : ${__FLEXI_PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}%n@%m:%~\$ "}
  : ${__FLEXI_PROMPT_UNPRINTABLE_PREFIX:="%{"}
  : ${__FLEXI_PROMPT_UNPRINTABLE_SUFFIX:="%}"}
  : ${__FLEXI_PROMPT_TITLE_PREFIX:="\e]0;"}
  : ${__FLEXI_PROMPT_TITLE_SUFFIX:="\007"}
  : ${__FLEXI_PROMPT_GIT_UNTRACKED_FILES:="%%"}
  : ${__FLEXI_PROMPT_PS2:=0}
  : ${__FLEXI_PROMPT_PS4:=0}
}

# Load flexi prompt
bashChangePrompt 'flexi'
# Initial prompt build
flexiPromptTheme

# Register hooks
autoload -U add-zsh-hook
add-zsh-hook preexec __flexiPromptPreExec
add-zsh-hook precmd __flexiPromptPreCmd

# ── Async git status ──────────────────────────────────────────────────────────
# &! background job computes git status and writes the result atomically to a
# temp file, then sends SIGWINCH to the parent shell. TRAPWINCH reads the file
# and calls `zle reset-prompt` for an immediate live redraw — no Enter needed.
#
# TRAPWINCH is re-registered on every precmd because startup scripts
# (mise, ext dotfiles) clear it after the prompt is loaded.
# Re-defining a small function costs <1ms and is safe.
#
# The drain (_flexi_update_git_cache called at precmd start) handles the case
# where SIGWINCH fires while a command is running — the next Enter picks it up.

# Preserve the original sync implementation before overriding it.
functions[__flexiPromptGitStatusSync]=$functions[__flexiPromptGitStatus]

typeset -g _FLEXI_GIT_STATUS_CACHED=""
typeset -g _FLEXI_GIT_RESULT_FILE="${TMPDIR:-/tmp}/.flexi_git_${$}"

# Replaces the sync version — returns cached result, or falls back to sync when FLEXI_GIT_SYNC=1.
__flexiPromptGitStatus() {
  [[ "${FLEXI_GIT_SYNC:-0}" = "1" ]] && { __flexiPromptGitStatusSync; return; }
  echo -n "$_FLEXI_GIT_STATUS_CACHED"
}

# Runs in a &! subshell — inherits all parent functions without emulate -R.
# $1=dir  $2=result_file  $3=parent_pid (for SIGWINCH notification)
_flexi_git_compute() {
  local dir="$1" result_file="$2" ppid="$3"
  cd "$dir" 2>/dev/null || { kill -WINCH "$ppid" 2>/dev/null; return; }
  local branch; branch="$(git_branch_status 2>/dev/null)"
  if [[ -z "$branch" ]]; then
    : > "${result_file}.tmp" 2>/dev/null && mv "${result_file}.tmp" "$result_file" 2>/dev/null
    kill -WINCH "$ppid" 2>/dev/null
    return
  fi
  local staged=0 unstaged=0 untracked=0
  read -r staged unstaged untracked <<< "$(git_status_flags 2>/dev/null)"
  local stash; stash="$(git_stash_size 2>/dev/null)"
  [[ -z "$stash" || "$stash" = "0" ]] && stash=""
  local upstream; upstream="$(git_upstream_status 2>/dev/null)"
  [[ "$upstream" = "=" ]] && upstream=""
  local out="${branch}|${staged}|${unstaged}|${untracked}|${stash}|${upstream}"
  printf '%s' "$out" > "${result_file}.tmp" 2>/dev/null \
    && mv "${result_file}.tmp" "$result_file" 2>/dev/null
  kill -WINCH "$ppid" 2>/dev/null
}

# Parse pipe-delimited result and update the cache.
_flexi_parse_git_output() {
  local output="$1"
  if [[ -z "$output" ]]; then
    _FLEXI_GIT_STATUS_CACHED=""
    return
  fi
  local branch staged unstaged untracked stash upstream
  IFS='|' read -r branch staged unstaged untracked stash upstream <<< "$output"
  local dirty=""
  [[ "$staged" = 1 ]]    && dirty+="$__FLEXI_PROMPT_GIT_STAGED_CHANGES"
  [[ "$unstaged" = 1 ]]  && dirty+="$__FLEXI_PROMPT_GIT_UNSTAGED_CHANGES"
  [[ "$untracked" = 1 ]] && dirty+="$__FLEXI_PROMPT_GIT_UNTRACKED_FILES"
  local markers=""
  [[ -n "$dirty" ]]    && markers+="$dirty"
  [[ -n "$stash" ]]    && markers+=" s${stash}"
  [[ -n "$upstream" ]] && markers+=" u${upstream}"
  _FLEXI_GIT_STATUS_CACHED="${__FLEXI_PROMPT_GIT_BEFORE}${branch}${markers}${__FLEXI_PROMPT_GIT_AFTER}"
}

# Drain: pick up any result the previous job wrote to the file.
_flexi_update_git_cache() {
  [[ -f "$_FLEXI_GIT_RESULT_FILE" ]] || return
  local output; output=$(< "$_FLEXI_GIT_RESULT_FILE")
  rm -f "$_FLEXI_GIT_RESULT_FILE"
  _flexi_parse_git_output "$output"
}

# Read .git/HEAD directly — no subprocess, no fork, instant.
# Only checks $PWD/.git (no tree traversal); subdirs get the branch via background job.
_flexi_show_branch_fast() {
  local gitdir="$PWD/.git"
  [[ -f "$gitdir" ]] && { local line; read -r line < "$gitdir" 2>/dev/null; gitdir="${line#gitdir: }"; [[ "$gitdir" != /* ]] && gitdir="$PWD/$gitdir"; }
  [[ ! -f "$gitdir/HEAD" ]] && return 1
  local head; read -r head < "$gitdir/HEAD" 2>/dev/null || return 1
  local branch
  if [[ "$head" == ref:* ]]; then
    branch="${head#ref: refs/heads/}"
  else
    branch="(${head:0:7}...)"
  fi
  _FLEXI_GIT_STATUS_CACHED="${__FLEXI_PROMPT_GIT_BEFORE}${branch}${__FLEXI_PROMPT_GIT_AFTER}"
  return 0
}

_flexi_async_git_refresh() {
  [[ "${FLEXI_GIT_SYNC:-0}" = "1" ]] && return
  # Re-register every precmd so startup scripts can't permanently clear it.
  TRAPWINCH() {
    _flexi_update_git_cache
    zle && zle reset-prompt
  }
  _flexi_update_git_cache
  # If cache is empty (first prompt after cd), show branch instantly from HEAD file.
  [[ -z "$_FLEXI_GIT_STATUS_CACHED" ]] && _flexi_show_branch_fast
  local ppid=$$
  _flexi_git_compute "$PWD" "$_FLEXI_GIT_RESULT_FILE" "$ppid" &!
}

_flexi_async_git_chpwd() {
  _FLEXI_GIT_STATUS_CACHED=""
  rm -f "$_FLEXI_GIT_RESULT_FILE" "${_FLEXI_GIT_RESULT_FILE}.tmp"
}

_flexi_git_cleanup() {
  rm -f "$_FLEXI_GIT_RESULT_FILE" "${_FLEXI_GIT_RESULT_FILE}.tmp"
}

add-zsh-hook precmd  _flexi_async_git_refresh
add-zsh-hook chpwd   _flexi_async_git_chpwd
add-zsh-hook zshexit _flexi_git_cleanup

# ── epoch override: zsh builtin instead of gdate subprocess ──────────────────
# __flexiPromptStartTimer and __flexiPromptHandleTimer each call $(epoch) which
# forks a subshell and spawns gdate (~5-10ms each). EPOCHREALTIME is a zsh
# special parameter — no fork, no process.
zmodload zsh/datetime 2>/dev/null

__flexiPromptStartTimer() {
  [[ -z "${__FLEXI_PROMPT_TIMER_START-}" ]] && typeset -g __FLEXI_PROMPT_TIMER_START=$EPOCHREALTIME
  [[ -z "${__FLEXI_PROMPT_TIMER_DIFF-}" ]] && unset __FLEXI_PROMPT_TIMER_DIFF
}

__flexiPromptHandleTimer() {
  local exit=$1
  unset __FLEXI_PROMPT_TIMER_DIFF
  [[ -z "${__FLEXI_PROMPT_TIMER_START-}" ]] && return $exit
  typeset -gi __FLEXI_PROMPT_TIMER_DIFF=$(( (EPOCHREALTIME - __FLEXI_PROMPT_TIMER_START) * 1000 ))
  unset __FLEXI_PROMPT_TIMER_START
  return $exit
}

# ── PS1 pre-computation ───────────────────────────────────────────────────────
# Prompt components are built once per precmd and stored in two variables.
# PS1 is three variable lookups — zero subshells at render time.
# SIGWINCH-triggered redraws (async git update) are instant: only
# _FLEXI_GIT_STATUS_CACHED changes, pre/post are already in place.

typeset -g _FLEXI_PS1_PRE=""
typeset -g _FLEXI_PS1_POST=""

_flexi_build_ps1() {
  local exit=$?
  local pre="" post=""
  [[ -n "${__FLEXI_PROMPT_NEWLINE_PRECMD-}" ]] && pre+="$(__flexiPromptNewLinePreCmd)"
  [[ -n "${__FLEXI_PROMPT_SHLVL-}" ]]          && pre+="$(__flexiPromptShlvl)"
  [[ -n "${__FLEXI_PROMPT_TIMESTAMP-}" ]]       && pre+="$(__flexiPromptTimestamp)"
  pre+="$(__flexiPromptDebianChroot)"
  pre+="$(__flexiPromptUserAtHost)"
  pre+="$(__flexiPromptPwd)"
  if [[ "${FLEXI_GIT_SYNC:-0}" = "1" && -n "${__FLEXI_PROMPT_GIT-}" ]]; then
    pre+="$(__flexiPromptGitStatusSync)"
    _FLEXI_GIT_STATUS_CACHED=""
  fi
  [[ -n "${__FLEXI_PROMPT_TIMER-}" ]]   && post+="$(__flexiPromptTimer)"
  [[ -n "${__FLEXI_PROMPT_NEWLINE-}" ]] && post+="$(__flexiPromptNewLine)"
  post+="$(__flexiPromptCmdSign $exit)"
  _FLEXI_PS1_PRE="$pre"
  _FLEXI_PS1_POST="$post"
  PS1='${_FLEXI_PS1_PRE}${_FLEXI_GIT_STATUS_CACHED}${_FLEXI_PS1_POST}'
  return $exit
}

add-zsh-hook precmd _flexi_build_ps1
