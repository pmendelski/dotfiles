#!/bin/bash
input=$(cat)
msg=$(jq -r '"Permission request: \(.tool_name)"' <<< "$input")
session=$(jq -r '.session_id // ""' <<< "$input")
~/.claude/hooks/notify.sh permission "$msg" "$session"
