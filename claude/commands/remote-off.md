Disable remote Telegram notifications for the current session by running this bash command:

```bash
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
session=$(cat "$config_dir/session-pids/$PPID" 2>/dev/null || cat "$config_dir/current-session" 2>/dev/null)
if [[ -z "$session" ]]; then
  echo "Error: could not determine current session ID"
  exit 1
fi
rm -f "$config_dir/remote-sessions/$session"
echo "Remote notifications disabled for session $session"
```

Report the result to the user in one sentence.
