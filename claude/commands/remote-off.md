Disable remote Telegram notifications for the current session by running this bash command:

```bash
session=$(cat ~/.claude/current-session 2>/dev/null)
if [[ -z "$session" ]]; then
  echo "Error: could not determine current session ID"
  exit 1
fi
rm -f ~/.claude/remote-sessions/"$session"
echo "Remote notifications disabled for session $session"
```

Report the result to the user in one sentence.
