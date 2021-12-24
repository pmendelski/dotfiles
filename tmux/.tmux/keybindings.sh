#!/usr/bin/env bash

# Miscalenious
# ============
# Make Ctrl combination work again
# See: http://superuser.com/a/402084
set-window-option -g xterm-keys on
# More like vim
setw -g mode-keys vi
# Reload config file (change file location to your the tmux.conf you want to use)
# bind r source-file ~/.tmux.conf \; display "Reloaded!"
bind r source-file ~/.tmux.conf
bind D send-keys "sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/tmux/readme.md' 1>&2 2>/dev/null &" Enter
# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
set -g status-keys emacs
# Toggle status for zen experience
bind z set status

# Mouse
# =====
# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on
# Toggle mouse on/off
bind m \
  set -g mouse on \;\
  display 'Mouse: ON'
bind M \
  set -g mouse off \;\
  display 'Mouse: OFF'

# Sessions
# ========
# Kill session
bind K confirm kill-server
# Next and previous session
bind -n M-> switch-client -n
bind -n M-< switch-client -p
bind -n M-M switch-client -l

# Windows
# =======
# Kill window
bind k confirm kill-window
# Move window to the top (change number to 1)
bind T swap-window -t 1
# Next and previous window
bind -n M-. next-window
bind -n M-, previous-window
bind -n M-m last-window

# Panes
# =====
# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind \\ split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %
# Move pane to the top
bind P swap-pane -t 1
# Switch panes using Alt-Arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# Delete pane
bind x kill-pane
# Synchronize all panes in a window
bind _ setw synchronize-panes

# Copy mode
# =========
# Delete recent buffer - '-' is used to split panes
bind + delete-buffer
# enter copy mode & scroll - breaks vim keybindings
# bind -n C-PPage copy-mode -u
# bind -n C-Up copy-mode \; send-keys C-y
# bind -n C-Down copy-mode \; send-keys C-e
# Enable Ctrl + arrows in copy mode-keys
bind -T copy-mode-vi C-Left send-keys -X previous-word
bind -T copy-mode-vi C-Right send-keys -X next-word
# For older version
# bind -t vi-copy C-Left previous-word
# bind -t vi-copy C-Right next-word
