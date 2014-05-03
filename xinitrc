#Change keymap to US with åäö
#Caps Lock as backspace included
xbindkeys &
setxkbmap usaswe

#Set the font
xset +fp /usr/share/fonts/local
xset fp rehash

#Turn off power management and screensaver
xset -dpms s off

#Set key repeat speed
xset r rate 250 25

#Make caps lock backspace repeat
xset r 66

#Add directories to path
export PATH=$HOME/scripts:$HOME/bin:$HOME/.cabal/bin:$PATH:$HOME/Desktop/

#Background image
sh ~/.fehbg

#Hide mouse cursor
unclutter &

#Autostart home network for convenience
sudo netctl start zyxel &

#Autostart Firefox
#firefox &

#Start xserver
exec xmonad
