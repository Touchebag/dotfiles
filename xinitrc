#tint2 &
xbindkeys &
setxkbmap usaswe

xset +fp /usr/share/fonts/local
xset fp rehash

export PATH=$HOME/scripts:$HOME/bin:$HOME/.cabal/bin:$PATH

panel

exec openbox-session
