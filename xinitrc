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

# Load Xresources
xrdb ~/.Xresources

# Move cursor out of the way
xdotool mousemove 2000 0
# Hide mouse cursor
unclutter &

# Autostart Firefox
firefox &

# Start xserver
exec xmonad
