#!/usr/bin/env bash
# Switch to any window across all sessions via fzf, sorted by recent access.
# ctrl-s: alpha sort | ctrl-r: recent sort
# Sessions whose names begin with _ are hidden.

fzf_bin="fzf"
script="$0"

_list_recent() {
  tmux list-windows -a \
    -F '#{window_activity} #{session_name}:#{window_index} #{window_name}' \
    | grep -Ev '^\S+ _' \
    | sort -rn \
    | awk '{$1=""; sub(/^ /, ""); print}'
}

_list_alpha() {
  tmux list-windows -a \
    -F '#{session_name}:#{window_index} #{window_name}' \
    | grep -v '^_' \
    | sort -V
}

case "${1-}" in
  --recent) _list_recent; exit ;;
  --alpha)  _list_alpha;  exit ;;
esac

selected=$(_list_recent | "$fzf_bin" \
  --no-sort \
  --reverse \
  --preview 'tmux capture-pane -ep -t {1}' \
  --preview-window=right:60% \
  --header 'ctrl-s: alpha  ctrl-r: recent [active]' \
  --bind "ctrl-s:reload(\"$script\" --alpha)+change-header(ctrl-s: alpha [active]  ctrl-r: recent)" \
  --bind "ctrl-r:reload(\"$script\" --recent)+change-header(ctrl-s: alpha  ctrl-r: recent [active])")

[ -n "$selected" ] && tmux switch-client -t "$(echo "$selected" | awk '{print $1}')"
