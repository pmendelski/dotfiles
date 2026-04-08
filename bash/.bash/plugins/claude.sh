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
  [[ "$ap" == "pm" && "$h" != "12" ]] && h=$(( h + 12 ))
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
  [[ "$ts" -le "$now" ]] && ts=$(( ts + 86400 ))
  echo "$ts"
}

function claude-wait() {
  # Usage: claude-wait ["Your custom message"]
  # Waits until Claude rate limit resets, then resumes the current session.
  # Uses a polling loop so system suspend/resume doesn't break the wait.
  local message="${1:-go on}"

  local session_id
  session_id=$(cat ~/.claude/current-session 2>/dev/null)
  [[ -n "$session_id" ]] && echo "Will resume session: $session_id" \
    || echo "No current session found, will continue most recent"

  # Exit code is the reliable availability signal (0 = ok, non-zero = rate limited).
  # Reset time parsed from output drives the countdown; rechecked every 5 min in case
  # extra tokens were purchased or the estimate shifts.
  local check_interval=300
  local reset_ts=0

  while true; do
    local output
    output=$(claude -p 'x' 2>&1)
    if [[ $? -eq 0 ]]; then
      printf '\r\033[K'
      echo "Tokens available!"
      break
    fi

    # Parse "resets 2am (Europe/Warsaw)" from the error output
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
    next_check=$(( now + check_interval ))

    while true; do
      now=$(date +%s)
      [[ $now -ge $next_check ]] && break
      local until_check=$(( next_check - now ))
      if [[ $reset_ts -gt $now ]]; then
        local until_reset=$(( reset_ts - now ))
        printf '\rRate limited — resets in %d:%02d:%02d  (recheck in %d:%02d)  ' \
          "$((until_reset / 3600))" "$(( (until_reset % 3600) / 60 ))" "$((until_reset % 60))" \
          "$((until_check / 60))" "$((until_check % 60))"
      else
        printf '\rRate limited — rechecking in %d:%02d...  ' \
          "$((until_check / 60))" "$((until_check % 60))"
      fi
      sleep 1
    done
    printf '\r\033[K'
  done

  if [[ -n "$session_id" ]]; then
    claude --permission-mode acceptEdits --resume "$session_id" "$message"
  else
    claude --permission-mode acceptEdits -c "$message"
  fi
}

function claude-remote() {
  CLAUDE_REMOTE=1 claude remote-control --spawn=same-dir "$@"
}

function claude2() {
  CLAUDE_CONFIG_DIR=~/.claude2 claude "$@"
}
