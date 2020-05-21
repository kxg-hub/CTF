# create or add this to ur ~/.tmux.conf 

#set prefix
set -g prefix C-a
bind C-a send-prefix
unbind C-b

set -g history-limit 100000
set -g allow-rename off

bind-key j command-prompt -p "Join pan from:" "join-pane -s '%%'"
bind-key s command-prompt -p "Send pane to:" "join-pane -t '%%'"

set-window-option -g mode-keys vi

bind '"'  split-window -h -c '#{pane_current_path}'  # Split panes horizontal
bind % split-window -v -c '#{pane_current_path}'  # Split panes vertically
bind c new-window -c "#{pane_current_path}" # Stay in path with new pane

run-shell /opt/tmux-logging/logging.tmux
