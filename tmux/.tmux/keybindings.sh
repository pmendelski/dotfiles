#!/usr/bin/env bash

# Miscalenious
# ============
# Make Ctrl combination work again
# See: http://superuser.com/a/402084
set-window-option -g xterm-keys on
# More like vim
setw -g mode-keys vi
# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
set -g status-keys emacs

# Reload config file (change file location to your the tmux.conf you want to use)
# bind r source-file ~/.tmux.conf \; display "Reloaded!"
bind r source-file ~/.tmux.conf \; display "Reloaded tmux config"
bind D send-keys "sensible-browser 'https://github.com/pmendelski/dotfiles/blob/master/tmux/readme.md' 1>&2 2>/dev/null &" Enter

# Zen mode
# ========
# Toggle status for zen experience
bind Z set status
# Toggle pane zoom and toggles status bar
bind F12 resize-pane -Z \; if-shell "tmux list-panes -F '#F' | grep -q Z" "set -g status off" "set -g status on"

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
bind P swap-pane -t 3
# Switch panes using Alt-Arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# Delete pane
bind x kill-pane
# Synchronize all panes in a window
bind _ setw synchronize-panes
# Rotate panes
bind '{' rotate-window -U
bind '}' rotate-window -D
# Swap panes in window
bind -n C-S-Up swap-pane -t '{up-of}'
bind -n C-S-Down swap-pane -t '{down-of}'
bind -n C-S-Left swap-pane -t '{left-of}'
bind -n C-S-Right swap-pane -t '{right-of}'

# Copy mode
# =========
# Delete recent buffer - '-' is used to split panes
bind + delete-buffer
# Enable Ctrl + arrows in copy mode-keys
bind -T copy-mode-vi C-Left send-keys -X previous-word
bind -T copy-mode-vi C-Right send-keys -X next-word
