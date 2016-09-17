# Initialize plugins

set -g @resurrect-dir '~/.tmux/tmp/resurrect'
run-shell ~/.tmux/bundles/tmux-resurrect/resurrect.tmux
run-shell ~/.tmux/bundles/tmux-continuum/continuum.tmux
