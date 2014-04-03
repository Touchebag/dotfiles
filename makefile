here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p }' | egrep -v '^.PHONY' | egrep -v '^all'

all: bash keylayout scripts xbindkeys xinitrc xmonad zsh

bar:
	@read -p 'WARNING: This requires bar to be positioned in ../bar'
	cp $(here)/bar/config.h ../bar/
	make -C ../bar/
	cp ../bar/bar $(here)/bar/
	ln -fsn $(here)/bar/bar $(HOME)/bin/bar

bash:
	ln -fsn $(here)/bashrc $(HOME)/.bashrc

keylayout:
	ln -fsn $(here)/usaswe /usr/share/X11/xkb/symbols/usaswe

openbox:
	mkdir -p $(HOME)/.config/openbox
	ln -fsn $(here)/openbox/rc.xml $(HOME)/.config/openbox/rc.xml
	ln -fsn $(here)/openbox/autostart $(HOME)/.config/openbox/autostart

scripts:
	ln -fsn $(here)/scripts $(HOME)/scripts

xbindkeys:
	ln -fsn $(here)/xbindkeysrc $(HOME)/.xbindkeysrc

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc

xmonad:
	ln -fsn $(here)/xmonad.hs $(HOME)/.xmonad/xmonad.hs

zsh:
	ln -fsn $(here)/zprofile $(HOME)/.zprofile

.PHONY: bar bash keylayout openbox scripts xbindkeys xinitrc xmonad zsh
