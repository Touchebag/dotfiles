# Change keymap to US with åäö
# Caps Lock as backspace included
xbindkeys &
setxkbmap usaswe_customsymbols

# Set menu key as compose
setxkbmap -option compose:menu

# Set the font
xset +fp /usr/share/fonts/local
xset fp rehash

# Turn off power management and screensaver
xset -dpms s off

# Set key repeat speed
xset r rate 250 25

# Make caps lock backspace repeat
xset r 66

# Add directories to path
export PATH=$HOME/scripts:$HOME/bin:$HOME/.cabal/bin:$PATH:$HOME/Desktop/

# Make vim default editor
export EDITOR=vim

# Auto mounting external drives
udiskie -F -N &

# Set initial background before cron job takes over
~/scripts/background &

# Hide mouse cursor
unclutter &

# Load Xresources
xrdb ~/.Xresources

# Setup time syncronization daemon
sudo ntpd -u ntp:ntp

# Move cursor and turn off touchpad
xdotool mousemove 2000 0
synclient TouchpadOff=1

# Because auto-connect won't work
endor &

# Autostart Firefox
firefox &

# Start xserver
exec xmonad
