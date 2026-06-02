#!/usr/bin/env bash
# Searchable keybinding reference.
# $1: nvim | vim | tmux | pane_current_command
# $2: editor to return to (only used when $1 = tmux)

script="$0"
# $1 used by fzf reload (nvim/vim/tmux); temp file written by tmux run-shell for initial call
view="${1:-$(cat /tmp/tmux-f12-pane-cmd 2>/dev/null)}"
back="${2:-}"

_nvim_bindings() {
  cat <<'EOF'
── nvim  (<leader> = Space) ──────────────────────────────────────────────────
§                 | nvim           | Esc  (macOS)
ctrl-s            | nvim           | Save
q                 | nvim           | Quit buffer (confirm)
Q                 | nvim           | Quit all (confirm)
ctrl-d            | nvim           | Duplicate line / selection
alt-j / alt-k     | nvim           | Move line / selection down / up
> / < (visual)    | nvim           | Indent / unindent (stay in mode)
ctrl-/            | nvim           | Toggle comment
ctrl-← → ↑ ↓      | nvim           | Navigate splits
<leader>|         | nvim           | Split vertically
<leader>o         | nvim           | Open URL under cursor
<leader>rb        | nvim           | Reload all unmodified buffers
<leader>rr        | nvim           | Reload LSP + buffer
<leader>t / T     | nvim test      | Run test under cursor / all in file
<leader>ml/mb/mr  | nvim diff      | Use LOCAL / BASE / REMOTE
── nvim navigation ───────────────────────────────────────────────────────────
S-h / S-l         | nvim nav       | Prev / next buffer
ctrl-o / ctrl-i   | nvim nav       | Jump backward / forward (jumplist)
gf                | nvim nav       | Go to file under cursor
%                 | nvim nav       | Jump to matching bracket
zo / zc / za      | nvim nav       | Fold open / close / toggle
zR / zM           | nvim nav       | Open all / close all folds
── nvim pickers ──────────────────────────────────────────────────────────────
<leader>ff        | nvim picker    | Find files (root dir)
<leader>fF        | nvim picker    | Find files (cwd)
<leader>fr / fR   | nvim picker    | Recent files (root / cwd)
<leader>fb        | nvim picker    | Buffers
<leader>/         | nvim picker    | Grep (root dir)
<leader>sg / sG   | nvim picker    | Grep root / cwd
<leader>sw / sW   | nvim picker    | Search word / selection (root / cwd)
<leader>ss / sS   | nvim picker    | Symbols (file / workspace)
<leader>sd        | nvim picker    | Diagnostics
<leader>sh        | nvim picker    | Help pages
<leader>sk        | nvim picker    | Keymaps
── nvim LSP & code ───────────────────────────────────────────────────────────
gd / gD           | nvim LSP       | Go to definition / declaration
gr                | nvim LSP       | Go to references
gi                | nvim LSP       | Go to implementation
K                 | nvim LSP       | Hover docs
<leader>ca        | nvim LSP       | Code action
<leader>cr        | nvim LSP       | Rename symbol
<leader>cf        | nvim LSP       | Format
<leader>cd        | nvim LSP       | Line diagnostics
]d / [d           | nvim LSP       | Next / prev diagnostic
]e / [e           | nvim LSP       | Next / prev error
── nvim git ──────────────────────────────────────────────────────────────────
<leader>gg        | nvim git       | Lazygit
]h / [h           | nvim git       | Next / prev hunk
<leader>ghs       | nvim git       | Stage hunk
<leader>ghu       | nvim git       | Undo stage hunk
<leader>ghp       | nvim git       | Preview hunk
<leader>ghb       | nvim git       | Blame line
── nvim panels ───────────────────────────────────────────────────────────────
F1                | nvim           | Toggle floating terminal
F2                | nvim           | Toggle bottom terminal
F3                | nvim           | Toggle explorer focus
F4                | nvim           | Toggle explorer
── nvim buffers ──────────────────────────────────────────────────────────────
<leader>bb        | nvim           | Switch buffer
<leader>bd        | nvim           | Delete buffer
<leader>bp        | nvim           | Pin buffer
<leader>bD        | nvim           | Delete non-pinned buffers
gcc               | nvim           | Comment line
gc (visual)       | nvim           | Comment selection
── nvim UI toggles ───────────────────────────────────────────────────────────
<leader>uf        | nvim toggle    | Toggle auto-format (buffer)
<leader>uF        | nvim toggle    | Toggle auto-format (global)
<leader>us        | nvim toggle    | Toggle spell check
<leader>uw        | nvim toggle    | Toggle word wrap
<leader>ul        | nvim toggle    | Toggle line numbers
<leader>ud        | nvim toggle    | Toggle diagnostics
<leader>uh        | nvim toggle    | Toggle inlay hints
EOF
}

_vim_bindings() {
  cat <<'EOF'
── vim motions ───────────────────────────────────────────────────────────────
h/j/k/l           | vim nav        | Left / down / up / right
w / b / e         | vim nav        | Word forward / back / end
0 / ^/ $          | vim nav        | Line start (col0) / (non-blank) / end
gg / G            | vim nav        | File start / end
ctrl-d / ctrl-u   | vim nav        | Half page down / up
ctrl-f / ctrl-b   | vim nav        | Full page down / up
── vim editing ───────────────────────────────────────────────────────────────
i / a / o / O     | vim edit       | Insert: before / after / below / above
d / y / p / P     | vim edit       | Delete / yank / paste after / before
u / ctrl-r        | vim edit       | Undo / redo
>> / <<           | vim edit       | Indent / unindent line
. (dot)           | vim edit       | Repeat last change
── vim search ────────────────────────────────────────────────────────────────
/pattern          | vim search     | Search forward
n / N             | vim search     | Next / prev match
* / #             | vim search     | Search word forward / back
:%s/old/new/g     | vim search     | Replace all
── vim visual & macros ───────────────────────────────────────────────────────
v / V / ctrl-v    | vim visual     | Char / line / block visual
q{a} / @{a}       | vim macro      | Record / play macro
── vim commands ──────────────────────────────────────────────────────────────
:w / :q / :wq     | vim cmd        | Save / quit / save+quit
:q!               | vim cmd        | Quit without saving
EOF
}

_tmux_bindings() {
  cat <<'EOF'
── tmux  (<prefix> = C-a) ────────────────────────────────────────────────────
<prefix> f        | tmux           | Switch windows in session  (ctrl-s: alpha · ctrl-r: recent)
<prefix> F        | tmux           | Switch windows across all sessions
<prefix> a        | tmux           | AI pane picker
<prefix> A        | tmux           | Jump to AI pane awaiting input
<prefix> s        | tmux           | Choose session
<prefix> S        | tmux           | New named session
<prefix> K        | tmux           | Kill session
<prefix> C        | tmux           | New named window
<prefix> &        | tmux           | Kill window
<prefix> .        | tmux           | Move window to index
<prefix> P / N    | tmux           | Swap window left / right
<prefix> 1–9      | tmux           | Jump to window by index
<prefix> %        | tmux           | Split pane horizontally
<prefix> "        | tmux           | Split pane vertically
<prefix> x        | tmux           | Kill pane
<prefix> _        | tmux           | Toggle pane synchronization
<prefix> Z        | tmux           | Zen mode (fullscreen + hide statusbar)
<prefix> g        | tmux           | Open lazygit
<prefix> r        | tmux           | Reload tmux config
<prefix> X        | tmux           | Kill tmux server (confirm)
F2                | tmux global    | Scratch terminal toggle
F12               | tmux global    | This keybinding reference
M-[  /  M-]       | tmux global    | Pane history: back / forward
M-← → ↑ ↓         | tmux global    | Switch pane by direction
PageUp / Down     | tmux global    | Scroll (enters copy mode, skips in vim)
S-Up / S-Down     | tmux global    | Enter copy mode + scroll line
EOF
}

_shell_bindings() {
  cat <<'EOF'
── shell / fzf ───────────────────────────────────────────────────────────────
ctrl-r            | shell / fzf    | Search command history
ctrl-t            | shell / fzf    | Find and insert file/dir path
alt-c             | shell / fzf    | cd to directory
── fzf pickers ───────────────────────────────────────────────────────────────
ctrl-s            | fzf pickers    | Sort: alphabetical
ctrl-r            | fzf pickers    | Sort: recent
ctrl-/            | fzf pickers    | Cycle preview layout: right → down → hidden
shift-↑ / ↓       | fzf pickers    | Scroll preview up / down
ctrl-f / ctrl-b   | fzf pickers    | Page preview down / up
ctrl-g / f / d    | ctrl-t picker  | Reload: any / files only / dirs only
ctrl-y            | fzf            | Copy selection to clipboard + close
ctrl-e            | fzf            | Open selection in nvim
EOF
}

# Determine mode and which editor (if any)
case "$view" in
  nvim|vim) mode="editor"; editor="$view" ;;
  tmux)     mode="tmux";   editor="$back" ;;
  *)        mode="tmux";   editor="" ;;
esac

# Build tab-switch bind and header
extra_args=()
if [ "$mode" = "editor" ]; then
  fzf_header="  $editor  ·  alt-t: tmux  ·  Esc to close"
  extra_args=(
    --bind "alt-t:reload(\"$script\" tmux $editor)+change-header(  tmux · shell  ·  alt-t: $editor  ·  Esc to close)"
  )
elif [ -n "$editor" ]; then
  fzf_header="  tmux · shell  ·  alt-t: $editor  ·  Esc to close"
  extra_args=(
    --bind "alt-t:reload(\"$script\" $editor)+change-header(  $editor  ·  alt-t: tmux  ·  Esc to close)"
  )
else
  fzf_header="  tmux · shell  ·  Esc to close"
fi

{
  case "$mode" in
    editor)
      [ "$editor" = "nvim" ] && _nvim_bindings || _vim_bindings
      ;;
    *)
      _tmux_bindings
      _shell_bindings
      ;;
  esac
} | column -t -s '|' | fzf \
  --no-sort \
  --header "$fzf_header" \
  --color 'header:italic' \
  --layout reverse \
  --height 100% \
  "${extra_args[@]}"
