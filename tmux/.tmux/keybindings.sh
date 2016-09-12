#!/bin/bash

# Make Ctrl combination work again
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

# Reload config file (change file location to your the tmux.conf you want to use)
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Switch panes using Alt-Arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Maximize and restore windows
unbind Up
bind Up new-window -d -n fullscreen \; swap-pane -s fullscreen.1 \; select-window -t fullscreen
unbind Down
bind Down last-window \; swap-pane -s fullscreen.1 \; kill-window -t fullscreen

# Move window to the top (change number to 1)
bind-key T swap-window -t 1

# Kill window and session
bind k confirm kill-window
bind K confirm kill-server

# Automatically copy to system clipboard
bind -t vi-copy y copy-pipe "xclip -sel clip -i"
