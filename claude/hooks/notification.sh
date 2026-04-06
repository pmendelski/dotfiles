#!/bin/bash
input=$(cat)
msg=$(jq -r '.message // "Needs your attention"' <<< "$input")
session=$(jq -r '.session_id // ""' <<< "$input")

# Skip noisy low-value notifications
case "$msg" in
  *"waiting for your input"*) exit 0 ;;
esac

~/.claude/hooks/notify.sh notification "$msg" "$session"
