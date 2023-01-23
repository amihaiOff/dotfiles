#!/bin/bash

SESSION_NAME="my_session"

#kill previous session
byobu kill-session -t $SESSION_NAME

#Create new session. I named this LeftMonitor for obvious reasons
byobu new-session -d -s $SESSION_NAME

#Select default pane. Probably an unnecessary line of code
byobu select-pane -t 0

#Split pane 0 into two vertically stacked panes
byobu split-window -h

#Select the newly created pane 1. Again, probably unnecessary as the new pane gets selected after a split
byobu select-pane -t 1

#Split pane 1 horizontally to create two side-by-side panes
byobu split-window -v

#Select pane to interact with
byobu select-pane -t 1

byobu send-keys "bpytop" Enter

byobu select-pane -t 2
byobu send-keys "ipython" Enter

byobu new-window -n Remote

# ssh into remote machine
byobu send-keys "ssh_ami" Enter

#Select default pane. Probably an unnecessary line of code
byobu select-pane -t 0

#Split pane 0 into two vertically stacked panes
byobu split-window -h

#Select the newly created pane 1. Again, probably unnecessary as the new pane gets selected after a split
byobu select-pane -t 1

#Pass a command to the selected pane. I'm using top as the example here.
#Note that you need to type Enter for byobu to simulate pressing the enter key.
byobu send-keys "ssh_ami" Enter
byobu send-keys "bpytop" Enter


byobu
