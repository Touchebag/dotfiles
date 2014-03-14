here := $(shell pwd)

help:
	@echo "Select a target"

all: bar bash keylayout openbox xinitrc xmonad

bar:
	ln -fsn $(here)/scripts/panel $(HOME)/scripts/panel
	ln -fsn $(here)/scripts/panel_conky $(HOME)/scripts/panel_conky
	ln -fsn $(here)/scripts/panel_battery $(HOME)/scripts/panel_battery
	ln -fsn $(here)/scripts/panel_volume $(HOME)/scripts/panel_volume
	ln -fsn $(here)/scripts/panel_trayer $(HOME)/scripts/panel_trayer

bash:
	ln -fsn $(here)/bashrc $(HOME)/.bashrc

keylayout:
	ln -fsn $(here)/usaswe /usr/share/X11/xkb/symbols/usaswe

openbox:
	mkdir -p $(HOME)/.config/openbox
	ln -fsn $(here)/openbox/rc.xml $(HOME)/.config/openbox/rc.xml
	ln -fsn $(here)/openbox/autostart $(HOME)/.config/openbox/autostart

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc

xmonad:
	ln -fsn $(here)/xmonad.hs $(HOME)/.xmonad/xmonad.hs

.PHONY: bar bash keylayout openbox xinitrc xmonad
