#!/usr/bin/env bash
# Searchable keybinding reference  (<prefix> = C-a)

_bindings() {
  cat <<'EOF'
<prefix> f       | tmux           | Switch windows in session  (ctrl-s: alpha · ctrl-r: recent)
<prefix> F       | tmux           | Switch windows across all sessions
<prefix> a       | tmux           | AI pane picker
<prefix> A       | tmux           | Jump to AI pane awaiting input
<prefix> s       | tmux           | Choose session
<prefix> S       | tmux           | New named session
<prefix> K       | tmux           | Kill session
<prefix> C       | tmux           | New named window
<prefix> &       | tmux           | Kill window
<prefix> .       | tmux           | Move window to index
<prefix> P / N   | tmux           | Swap window left / right
<prefix> 1–9     | tmux           | Jump to window by index
<prefix> %       | tmux           | Split pane horizontally
<prefix> "       | tmux           | Split pane vertically
<prefix> x       | tmux           | Kill pane
<prefix> _       | tmux           | Toggle pane synchronization
<prefix> Z       | tmux           | Zen mode (fullscreen + hide statusbar)
<prefix> g       | tmux           | Open lazygit
<prefix> r       | tmux           | Reload tmux config
<prefix> X       | tmux           | Kill tmux server (confirm)
F2               | tmux global    | Scratch terminal toggle
F12              | tmux global    | This keybinding reference
M-[  /  M-]      | tmux global    | Pane history: back / forward
M-← → ↑ ↓        | tmux global    | Switch pane by direction
PageUp/Down      | tmux global    | Scroll (enters copy mode, skips if in vim)
S-Up / S-Down    | tmux global    | Enter copy mode + scroll line
ctrl-r           | shell / fzf    | Search command history
ctrl-t           | shell / fzf    | Find and insert file/dir path
alt-c            | shell / fzf    | cd to directory
ctrl-s           | fzf pickers    | Sort: alphabetical
ctrl-r           | fzf pickers    | Sort: recent
ctrl-/           | fzf pickers    | Cycle preview layout: right → down → hidden
shift-↑ / ↓      | fzf pickers    | Scroll preview up / down
ctrl-f / ctrl-b  | fzf pickers    | Page preview down / up
ctrl-g/f/d       | ctrl-t picker  | Reload: any / files only / dirs only
ctrl-y           | fzf            | Copy selection to clipboard + close
ctrl-e           | fzf            | Open selection in nvim
EOF
}

_bindings | column -t -s '|' | fzf \
  --no-sort \
  --header '  <prefix> = C-a  ·  type to search  ·  Esc to close' \
  --color 'header:italic' \
  --layout reverse \
  --height 100%
