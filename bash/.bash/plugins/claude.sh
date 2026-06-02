# Parse "2am" / "11:30pm" in a given timezone to a UTC epoch timestamp.
# Uses sed/grep instead of shell regex captures — works in bash and zsh on Linux and macOS.
_claude_reset_epoch() {
  local time_str="$1" tz="$2"

  local h m ap
  h=$(printf '%s' "$time_str" | sed 's/[^0-9].*//')
  ap=$(printf '%s' "$time_str" | grep -o '[ap]m')
  m=$(printf '%s' "$time_str" | sed -n 's/[0-9]*:\([0-9]*\)[ap]m/\1/p')
  m=${m:-0}

  [[ -z "$h" || -z "$ap" ]] && return 1
  [[ "$ap" == "pm" && "$h" != "12" ]] && h=$((h + 12))
  [[ "$ap" == "am" && "$h" == "12" ]] && h=0
  local hhmm
  hhmm=$(printf '%02d:%02d' "$h" "$m")

  local ts now
  now=$(date +%s)
  # GNU date (Linux / Homebrew macOS)
  ts=$(TZ="$tz" date -d "$hhmm" +%s 2>/dev/null)
  if [[ $? -ne 0 || -z "$ts" ]]; then
    # BSD date (macOS) — explicit :00 seconds to avoid inheriting current seconds
    ts=$(TZ="$tz" date -j -f "%H:%M:%S" "${hhmm}:00" +%s 2>/dev/null) || return 1
  fi
  # If the time already passed today in that timezone, it must mean tomorrow
  [[ "$ts" -le "$now" ]] && ts=$((ts + 86400))
  echo "$ts"
}

# Invoke claude, setting CLAUDE_CONFIG_DIR only for non-default config dirs.
# Explicitly setting it to ~/.claude confuses Claude's own default resolution.
_claude_invoke() {
  local config_dir="$1"; shift
  if [[ "$config_dir" != "${HOME}/.claude" ]]; then
    CLAUDE_CONFIG_DIR="$config_dir" claude "$@"
  else
    claude "$@"
  fi
}

# Save the current-session ID into a tmux pane-local variable immediately after
# claude exits, before any other pane can overwrite the global current-session file.
# Variable is keyed by config dir basename (e.g. @claude_session_claude2) so
# multiple accounts in the same pane don't clobber each other.
_claude_save_session() {
  local config_dir="$1"
  [[ -n "${TMUX:-}" ]] || return 0
  local sid varname
  sid=$(cat "$config_dir/current-session" 2>/dev/null) || return 0
  varname="@claude_session_$(basename "$config_dir")"
  [[ -n "$sid" ]] && tmux set-option -p "$varname" "$sid" 2>/dev/null || true
}

# Poll until rate limit clears. Prints in-place status to /dev/tty. Returns 0 when done.
_claude_poll() {
  local config_dir="$1"
  # Suppress xtrace — variable assignments would produce unwanted noise on the terminal
  local _xt; _xt=${-//[^x]/}; set +x 2>/dev/null
  local check_interval=300 reset_ts=0

  while true; do
    local output
    output=$(_claude_invoke "$config_dir" -p 'x' 2>&1)
    if [[ $? -eq 0 ]]; then
      printf '\r\033[KTokens available!\n' >/dev/tty
      [[ -n "$_xt" ]] && set -x 2>/dev/null
      return 0
    fi

    local time_part tz_part
    time_part=$(printf '%s' "$output" | grep -oiE 'resets [0-9:]+[ap]m' | grep -oiE '[0-9:]+[ap]m' | tr '[:upper:]' '[:lower:]' | head -1)
    tz_part=$(printf '%s' "$output" | grep -oiE 'resets [0-9:]+[ap]m \([^)]+\)' | grep -oE '\([^)]+\)' | tr -d '()' | head -1)
    if [[ -n "$time_part" && -n "$tz_part" ]]; then
      local new_ts
      new_ts=$(_claude_reset_epoch "$time_part" "$tz_part") && reset_ts=$new_ts
    fi

    local now next_check remaining reset_disp status_msg
    now=$(date +%s)
    next_check=$((now + check_interval))

    while true; do
      now=$(date +%s)
      [[ $now -ge $next_check ]] && break
      remaining=$(( next_check - now ))
      if [[ $reset_ts -gt $now ]]; then
        reset_disp=$(date -r "$reset_ts" +"%H:%M %Z" 2>/dev/null || date -d "@$reset_ts" +"%H:%M %Z" 2>/dev/null)
        status_msg="Rate limited — resets ~${reset_disp}  (retry in ${remaining}s)"
      else
        status_msg="Rate limited — retry in ${remaining}s"
      fi
      printf '\r\033[K%s' "$status_msg" >/dev/tty
      sleep 1
    done
    printf '\r\033[K' >/dev/tty
  done
}

# Resolve session ID for --continue: explicit arg > tmux pane var > current-session file
_claude_resolve_session() {
  local config_dir="$1" explicit="$2"
  if [[ -n "$explicit" ]]; then
    printf '%s' "$explicit"
    return
  fi
  local sid=""
  if [[ -n "${TMUX:-}" ]]; then
    local varname="@claude_session_$(basename "$config_dir")"
    sid=$(tmux display-message -p "#{$varname}" 2>/dev/null)
    [[ "$sid" == "#{$varname}" ]] && sid=""
  fi
  [[ -z "$sid" ]] && sid=$(cat "$config_dir/current-session" 2>/dev/null)
  printf '%s' "$sid"
}

# claudex — unified Claude launcher
#
# Usage: claudex [OPTIONS] [ACTION] [-- ARGS...]
#
# Options:
#   -u N, --user N    Config dir ~/.claudeN  (N≥1; default: 1 → ~/.claude)
#   -r,   --remote    Remote-control spawn (sets CLAUDE_REMOTE=1)
#   -e,   --env       Source .env before launching
#   -h,   --help      Print this help
#   --helpx           Pass --help to claude
#
# Actions (all implicitly wait for rate-limit before acting):
#   --wait                           Poll until tokens available, exit 0
#   --continue [SESSION]             Resume SESSION (or last pane session) with 'go on'
#   --continue [SESSION] --prompt P  Resume SESSION with prompt P
#   --prompt P                       Start a new session with prompt P
#
#   Without an action, passes remaining ARGS directly to claude.
function claudex() {
  local user_num=1 do_remote=0 do_env=0
  local do_wait=0 do_continue=0 do_prompt=0
  local continue_session="" prompt=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        cat <<'EOF'
claudex — unified Claude launcher

Usage: claudex [OPTIONS] [ACTION] [-- ARGS...]

Options:
  -u N, --user N    Config dir ~/.claudeN  (N≥1; default: 1 → ~/.claude)
  -r,   --remote    Remote-control spawn (sets CLAUDE_REMOTE=1)
  -e,   --env       Source .env before launching
  -h,   --help      Print this help
  --helpx           Pass --help to claude

Actions (all wait for rate-limit before acting):
  --wait                            Poll until tokens available, exit 0
  --continue [SESSION]              Resume SESSION (or last pane session) with 'go on'
  --continue [SESSION] --prompt P   Resume SESSION with prompt P
  --prompt P                        Start a new session with prompt P

  Without an action, passes remaining args directly to claude.

Examples:
  claudex --wait && notify 'Tokens available!'
  claudex --continue
  claudex --continue abc-123
  claudex --continue --prompt 'continue the refactor'
  claudex --continue abc-123 --prompt 'push through to completion'
  claudex --prompt 'explain this codebase'
  claudex -u 2 --prompt 'review this PR'
  claudex --helpx
EOF
        return 0 ;;
      --helpx)
        claude --help; return ;;
      -u|--user)
        [[ $# -lt 2 ]] && { echo "claudex: --user requires an argument" >&2; return 1; }
        user_num="$2"; shift 2 ;;
      -r|--remote) do_remote=1; shift ;;
      -e|--env)    do_env=1;    shift ;;
      --wait)      do_wait=1;   shift ;;
      --continue)
        do_continue=1
        if [[ $# -ge 2 && "$2" != -* ]]; then
          continue_session="$2"; shift 2
        else
          shift
        fi ;;
      --prompt)
        [[ $# -lt 2 ]] && { echo "claudex: --prompt requires an argument" >&2; return 1; }
        do_prompt=1; prompt="$2"; shift 2 ;;
      --) shift; break ;;
      *) break ;;
    esac
  done

  if ! [[ "$user_num" =~ ^[1-9][0-9]*$ ]]; then
    echo "claudex: --user requires a positive integer (got: '$user_num')" >&2
    return 1
  fi

  local config_dir
  [[ "$user_num" -eq 1 ]] \
    && config_dir="${HOME}/.claude" \
    || config_dir="${HOME}/.claude${user_num}"

  [[ "$do_env" -eq 1 && -f .env ]] && source .env

  # --wait alone: poll until tokens clear, exit 0
  if [[ "$do_wait" -eq 1 && "$do_continue" -eq 0 && "$do_prompt" -eq 0 ]]; then
    _claude_poll "$config_dir"
    return
  fi

  # --continue and/or --prompt: wait then act
  if [[ "$do_continue" -eq 1 || "$do_prompt" -eq 1 ]]; then
    _claude_poll "$config_dir" || return 1

    local session_id
    session_id=$(_claude_resolve_session "$config_dir" "$continue_session")

    if [[ "$do_continue" -eq 1 ]]; then
      local msg="${prompt:-go on}"
      if [[ -n "$session_id" ]]; then
        _claude_invoke "$config_dir" --permission-mode acceptEdits --resume "$session_id" "$msg"
      else
        _claude_invoke "$config_dir" --permission-mode acceptEdits -c "$msg"
      fi
    else
      # --prompt alone: new session
      _claude_invoke "$config_dir" "$prompt" "$@"
    fi
    _claude_save_session "$config_dir"
    return
  fi

  # Plain invocation
  if [[ "$do_remote" -eq 1 ]]; then
    CLAUDE_REMOTE=1 _claude_invoke "$config_dir" remote-control --spawn=same-dir "$@"
  else
    _claude_invoke "$config_dir" "$@"
    _claude_save_session "$config_dir"
  fi
}

