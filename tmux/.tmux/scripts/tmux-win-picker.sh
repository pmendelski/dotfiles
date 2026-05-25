#!/usr/bin/env bash
# Switch windows within current session via fzf, sorted by recent access.
# ctrl-s: alpha sort | ctrl-r: recent sort

fzf_bin="fzf"
script="$0"

_list_recent() {
  tmux list-windows -F '#{window_activity} #{window_index} #{window_name}' \
    | sort -rn \
    | awk '{$1=""; sub(/^ /, ""); print}'
}

_list_alpha() {
  tmux list-windows -F '#{window_index} #{window_name}' | sort -k2
}

case "${1-}" in
  --recent) _list_recent; exit ;;
  --alpha)  _list_alpha;  exit ;;
esac

selected=$(_list_recent | "$fzf_bin" \
  --no-sort \
  --reverse \
  --preview 'tmux capture-pane -ep -t :{1}' \
  --preview-window=right:60% \
  --header 'ctrl-s: alpha  ctrl-r: recent [active]' \
  --bind "ctrl-s:reload(\"$script\" --alpha)+change-header(ctrl-s: alpha [active]  ctrl-r: recent)" \
  --bind "ctrl-r:reload(\"$script\" --recent)+change-header(ctrl-s: alpha  ctrl-r: recent [active])")

[ -n "$selected" ] && tmux select-window -t "$(echo "$selected" | awk '{print $1}')"
