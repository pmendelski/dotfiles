#!/bin/bash

# No sounds
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none

# The messages
set -g message-attr bold
set -g message-fg colour232
set -g message-bg colour166

# The modes
setw -g clock-mode-colour colour135
setw -g mode-attr bold
setw -g mode-fg colour130
setw -g mode-bg colour238

# The panes
set -g pane-border-fg colour238
set -g pane-active-border-fg colour243

# The statusbar
set -g status-utf8 on
set -g status-justify left
set -g status-position bottom
set -g status-interval 2
set -g status-bg default
set -g status-right '#[fg=colour248]#(whoami)@#(hostname -s) #[fg=colour230]%d/%m %H:%M:%S '
setw -g window-status-current-fg colour81
setw -g window-status-current-bg colour238
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
setw -g window-status-attr none
setw -g window-status-format ' #[fg=colour230]#I:#[fg=colour250]#W#[fg=colour230]#F '
