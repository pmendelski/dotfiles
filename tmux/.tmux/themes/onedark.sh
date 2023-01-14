#!/bin/bash
# https://github.com/odedlaz/tmux-onedark-theme/blob/master/tmux-onedark-theme.tmux

onedark_black="#282c34"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_visual_grey="#3e4452"

set -g mode-style "fg=$onedark_white,bg=$onedark_visual_grey"

# Messages
set -g message-style "fg=$onedark_white,bg=$onedark_visual_grey"
set -g message-command-style "fg=$onedark_white,bg=$onedark_visual_grey"

# Panes
set -g pane-border-style "fg=$onedark_visual_grey"
set -g pane-active-border-style "fg=$onedark_white"

# Status
set -g status "on"
set -g status-justify "left"
set -g status-style "fg=$onedark_white,bg=$onedark_black"
set -g status-left-length "100"
set -g status-right-length "100"
set -g status-left-style NONE
set -g status-right-style NONE
set -g status-left "#[fg=$onedark_black,bg=$onedark_green,bold] #S #[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_green,bg=$onedark_black] #{prefix_highlight} #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_visual_grey] %Y-%m-%d  %H:%M #[fg=$onedark_green,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_black,bg=$onedark_green,bold] #h "

# Window
setw -g window-status-activity-style "underscore,fg=$onedark_white,bg=$onedark_black"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$onedark_white,bg=$onedark_black"
setw -g window-status-format "#[fg=$onedark_black,bg=$onedark_visual_grey]#[fg=$onedark_white,bg=$onedark_visual_grey] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=$onedark_black,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_green,bg=$onedark_visual_grey,nobold] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"
