function claude-wait() {
  # Usage: claude-wait ["Your custom message"]
  # Waits until Claude rate limit resets, then resumes the current session.
  # Uses a polling loop so system suspend/resume doesn't break the wait.
  local message="${1:-go on}"

  # Capture the session ID now so we resume the right session after the wait,
  # regardless of which directory we're in when the wait completes.
  local session_id
  session_id=$(cat ~/.claude/current-session 2>/dev/null)

  if [[ -n "$session_id" ]]; then
    echo "Will resume session: $session_id"
  else
    echo "No current session found, will continue most recent in current directory"
  fi

  # Poll every 5 minutes until tokens are available.
  # A loop (not one long sleep) survives system suspend/resume correctly.
  local check_interval=300
  while true; do
    local output
    output=$(claude -p 'check' 2>&1)
    if ! echo "$output" | grep -qi 'resets'; then
      echo "Tokens available!"
      break
    fi
    local reset_time
    reset_time="${output##* resets }"
    printf '%s Rate limited — resets %s. Next check in %dm...\n' \
      "$(date '+%H:%M:%S')" "$reset_time" "$((check_interval / 60))"
    sleep "$check_interval"
  done

  if [[ -n "$session_id" ]]; then
    CLAUDE_REMOTE=1 claude --permission-mode acceptEdits --resume "$session_id" "$message"
  else
    CLAUDE_REMOTE=1 claude --permission-mode acceptEdits -c "$message"
  fi
}

function claude-remote() {
  CLAUDE_REMOTE=1 claude remote-control --spawn=same-dir "$@"
}

function claude2() {
  CLAUDE_CONFIG_DIR=~/.claude2 claude "$@"
}
