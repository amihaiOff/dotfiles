source $BYOBU_PREFIX/share/byobu/profiles/tmux
set -g status-right '#(byobu-status tmux_right)'
set -g pane-border-style fg=black
set -g pane-active-border-style fg=black
set-window-option -g window-status-current-style "bg=#333333,fg=#EEEEEE,underscore,us=gray"
set-window-option -g window-status-format "#W#{?window_flags,#{window_flags}, }"
set-window-option -g window-status-current-format "#W#{?window_flags,#{window_flags}, }"
