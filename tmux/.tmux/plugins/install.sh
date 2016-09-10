# Initialize plugins

set -g @resurrect-dir '~/.tmux/tmp/resurrect'
run-shell ~/.tmux/plugins/tmux-resurrect/resurrect.tmux
run-shell ~/.tmux/plugins/tmux-continuum/continuum.tmux
