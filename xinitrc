#Change keymap to US with åäö
xbindkeys &
setxkbmap usaswe

#Set the font
xset +fp /usr/share/fonts/local
xset fp rehash

#Turn off power management and screensaver
xset -dpms s off

#Add directories to path
export PATH=$HOME/scripts:$HOME/bin:$HOME/.cabal/bin:$PATH

#{{{Startup scripts
#Background image
sh ~/.fehbg

#Hide mouse cursor
unclutter &
#}}}

#Autostart home network for convenience
sudo netctl start zyxel &

#Start xserver
exec xmonad
#exec openbox-session
