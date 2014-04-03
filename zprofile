#!/bin/zsh

#Add directories to path
PATH="$HOME/scripts:$HOME/bin:$HOME/.cabal/bin:$PATH"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && /usr/bin/xinit $HOME/.xinitrc -- /etc/X11/xinit/xserverrc :0 &> /dev/null

