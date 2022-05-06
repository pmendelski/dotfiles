#!/usr/bin/env bash

# The messages
set -g message-style "bold,fg=colour232,bg=colour166"

# The modes
setw -g clock-mode-colour colour135
setw -g mode-style "bold,fg=colour130,bg=colour238"

# The panes
set -g pane-border-style "fg=colour238"
set -g pane-active-border-style "fg=colour243"

# The statusbar
set -g status-justify left
set -g status-position bottom
set -g status-interval 2
set -g status-style 'fg=colour062,bg=default'
set -g status-right '#{prefix_highlight} #[fg=colour068]#(whoami)@#(hostname -s) #[fg=colour062]%d/%m %H:%M:%S '
set -g status-right-length 50
setw -g window-status-current-style "bold,fg=colour075,bg=colour008"
setw -g window-status-current-format ' #I#[fg=colour074]:#[fg=colour255]#W#[fg=colour075]#F '
setw -g window-status-style "none"
setw -g window-status-format ' #[fg=colour086]#I:#[fg=colour250]#W#[fg=colour230]#F '
