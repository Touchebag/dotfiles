#!/bin/zsh

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && /usr/bin/xinit "$HOME/.xinitrc" -- /etc/X11/xinit/xserverrc :0 -layout Layout0 &> /dev/null

