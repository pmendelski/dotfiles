#!/bin/bash

# Make Ctrl combination work again
# See: http://superuser.com/a/402084
set-window-option -g xterm-keys on

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on
# Toggle mouse on/off
bind m \
  set -g mouse on \;\
  display 'Mouse: ON'
bind M \
  set -g mouse off \;\
  display 'Mouse: OFF'

# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Synchronize all panes in a window
bind y setw synchronize-panes

# Reload config file (change file location to your the tmux.conf you want to use)
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Switch panes using Alt-Arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Move window to the top (change number to 1)
bind-key T swap-window -t 1

# Kill window
bind k confirm kill-window
# Kill session
bind K confirm kill-server

# More like vim
setw -g mode-keys vi
bind -t vi-copy v begin-selection
bind -t vi-copy y copy-pipe "xclip -sel clip -i"

# Delete recent buffer
# Default '-' is used to split panes
bind + delete-buffer
