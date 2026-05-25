# Parse "2am" / "11:30pm" in a given timezone to a UTC epoch timestamp.
# Uses sed/grep instead of shell regex captures — works in bash and zsh on Linux and macOS.
_claude_reset_epoch() {
  local time_str="$1" tz="$2"

  # Extract components without BASH_REMATCH (not available in zsh by default)
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

# _claude_wait_impl <config_dir> [message]
_claude_wait_impl() {
  local config_dir="$1" message="${2:-go on}"

  local session_id
  session_id=$(cat "$config_dir/current-session" 2>/dev/null)
  [[ -n "$session_id" ]] && echo "Will resume session: $session_id" ||
    echo "No current session found, will continue most recent"

  local check_interval=300
  local reset_ts=0

  while true; do
    local output
    output=$(_claude_invoke "$config_dir" -p 'x' 2>&1)
    if [[ $? -eq 0 ]]; then
      printf '\r\033[K'
      echo "Tokens available!"
      break
    fi

    local lower_output time_part tz_part
    lower_output=$(printf '%s' "$output" | tr '[:upper:]' '[:lower:]')
    time_part=$(printf '%s\n' "$lower_output" | grep -o 'resets [0-9:]*[ap]m' | grep -o '[0-9:]*[ap]m')
    tz_part=$(printf '%s\n' "$lower_output" | sed -n 's/.*resets [0-9:]*[ap]m (\([^)]*\)).*/\1/p')
    if [[ -n "$time_part" && -n "$tz_part" ]]; then
      local new_ts
      new_ts=$(_claude_reset_epoch "$time_part" "$tz_part") && reset_ts=$new_ts
    fi

    local now next_check
    now=$(date +%s)
    next_check=$((now + check_interval))

    while true; do
      now=$(date +%s)
      [[ $now -ge $next_check ]] && break
      if [[ $reset_ts -gt $now ]]; then
        local reset_time
        reset_time=$(date -r "$reset_ts" +"%I:%M%p" 2>/dev/null || date -d "@$reset_ts" +"%I:%M%p" 2>/dev/null)
        printf '\rRate limited — resets at %s  ' "$reset_time"
      else
        printf '\rRate limited — rechecking...  '
      fi
      sleep 1
    done
    printf '\r\033[K'
  done

  if [[ -n "$session_id" ]]; then
    _claude_invoke "$config_dir" --permission-mode acceptEdits --resume "$session_id" "$message"
  else
    _claude_invoke "$config_dir" --permission-mode acceptEdits -c "$message"
  fi
}

# claudex — unified Claude launcher
#
# Usage: claudex [-u N] [-r] [-e] [-w] [args...]
#   -u N, --user N   config dir ~/.claudeN  (N>=1; N=1 → ~/.claude, the default)
#   -r,   --remote   remote-control spawn (CLAUDE_REMOTE=1)
#   -e,   --env      source .env before launching
#   -w,   --wait     poll until rate limit clears, then resume current session
#
# Flags are combinable: claudex -u 2 -r -e
function claudex() {
  local user_num=1 do_remote=0 do_env=0 do_wait=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -u|--user)
        [[ $# -lt 2 ]] && { echo "claudex: --user requires an argument" >&2; return 1; }
        user_num="$2"; shift 2 ;;
      -r|--remote) do_remote=1; shift ;;
      -e|--env)    do_env=1;    shift ;;
      -w|--wait)   do_wait=1;   shift ;;
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

  if [[ "$do_wait" -eq 1 ]]; then
    _claude_wait_impl "$config_dir" "$@"
  elif [[ "$do_remote" -eq 1 ]]; then
    CLAUDE_REMOTE=1 _claude_invoke "$config_dir" remote-control --spawn=same-dir "$@"
  else
    _claude_invoke "$config_dir" "$@"
  fi
}

# Backward-compatible wrappers
function claude-remote()  { claudex --remote "$@"; }
function claude-env()     { claudex --env "$@"; }
function claude2()        { claudex --user 2 "$@"; }
function claude2-remote() { claudex --user 2 --remote "$@"; }
function claude2-env()    { claudex --user 2 --env "$@"; }
function claude-wait()    { claudex --wait "$@"; }
function claude2-wait()   { claudex --user 2 --wait "$@"; }
