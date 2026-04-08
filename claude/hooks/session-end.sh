#!/bin/bash
session=$(jq -r '.session_id // ""')
[[ -z "$session" ]] && exit 0

rm -f ~/.claude/remote-sessions/"$session"
grep -rl "^${session}$" ~/.claude/session-pids/ 2>/dev/null | xargs rm -f 2>/dev/null
