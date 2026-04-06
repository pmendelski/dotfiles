#!/bin/bash
# Usage: notify.sh <event_type> <message> [session_id]
#   event_type: stop | notification | permission
#   message:    text to display/send
#   session_id: Claude session ID (used to check remote mode)
event_type="${1:-stop}"
message="${2:-Claude notification}"
session_id="${3:-}"

case "$event_type" in
stop)
  icon="✅"
  sound="Hero.aiff"
  ;;
notification)
  icon="ℹ️"
  sound="Ping.aiff"
  ;;
permission)
  icon="⚠️"
  sound="Sosumi.aiff"
  ;;
*)
  icon="ℹ️"
  sound="Ping.aiff"
  ;;
esac

display="${icon} ${message}"

# Local notifications (always)
terminal-notifier -title 'Claude Code' -message "$display" -activate 'com.mitchellh.ghostty' 2>/dev/null
afplay "/System/Library/Sounds/${sound}" 2>/dev/null

# Telegram (only for sessions marked as remote)
token="${TELEGRAM_AI_BOT_TOKEN:-$TELEGRAM_BOT_TOKEN}"
chat="${TELEGRAM_AI_CHAT_ID:-$TELEGRAM_CHAT_ID}"
if [[ -n "$session_id" && -f "$HOME/.claude/remote-sessions/$session_id" ]] &&
  [[ -n "$token" && -n "$chat" ]]; then
  curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
    -d chat_id="${chat}" \
    -d text="$display" 2>/dev/null || true
fi
