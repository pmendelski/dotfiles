#!/bin/bash
session=$(jq -r '.session_id // ""')
[[ -z "$session" ]] && exit 0

rm -f ~/.claude/remote-sessions/"$session"
