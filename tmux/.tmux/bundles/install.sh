# Initialize plugins

run-shell ~/.tmux/bundles/open/open.tmux
run-shell ~/.tmux/bundles/yank/yank.tmux
run-shell ~/.tmux/bundles/copycat/copycat.tmux

# https://github.com/tmux-plugins/tmux-prefix-highlight
set-option -g @prefix_highlight_show_copy_mode 'on'
run-shell ~/.tmux/bundles/prefix-highlight/prefix_highlight.tmux

# https://github.com/tmux-plugins/tmux-logging
set-option -g @logging-path "$HOME/.tmux/tmp/logging"
set-option -g @screen-capture-path "$HOME/.tmux/tmp/logging"
set-option -g @save-complete-history-path "$HOME/.tmux/tmp/logging"
run-shell "mkdir -p $HOME/.tmux/tmp/logging"
run-shell ~/.tmux/bundles/logging/logging.tmux
