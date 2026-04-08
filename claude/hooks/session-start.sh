#!/bin/bash
input=$(cat)
session=$(jq -r '.session_id // ""' <<< "$input")
[[ -z "$session" ]] && exit 0

echo "$session" > ~/.claude/current-session
mkdir -p ~/.claude/session-pids
echo "$session" > ~/.claude/session-pids/$PPID

if [[ "$CLAUDE_REMOTE" == "1" ]]; then
    mkdir -p ~/.claude/remote-sessions
    touch ~/.claude/remote-sessions/"$session"
fi
