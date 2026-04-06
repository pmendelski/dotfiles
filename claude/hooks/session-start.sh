#!/bin/bash
input=$(cat)
session=$(jq -r '.session_id // ""' <<< "$input")
[[ -z "$session" ]] && exit 0

echo "$session" > ~/.claude/current-session

if [[ "$CLAUDE_REMOTE" == "1" ]]; then
    mkdir -p ~/.claude/remote-sessions
    touch ~/.claude/remote-sessions/"$session"
fi
