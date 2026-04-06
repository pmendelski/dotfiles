#!/bin/bash
session=$(jq -r '.session_id // ""')
~/.claude/hooks/notify.sh stop 'Task complete' "$session"
