here := $(shell pwd)

help:
	@echo "Select a target"

all: bash keylayout scripts xbindkeys xinitrc xmonad

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

.PHONY: bash keylayout openbox scripts xbindkeys xinitrc xmonad
