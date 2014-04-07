here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p }' | egrep -v '^.PHONY' | egrep -v '^all'

all: bash keylayout scripts slim xbindkeys xinitrc xmonad zsh

bar:
	@read -p 'WARNING: This requires bar to be positioned in ../bar'
	cp $(here)/bar/config.h ../bar/
	make -C ../bar/
	cp ../bar/bar $(here)/bar/
	ln -fsn $(here)/bar/bar $(HOME)/bin/bar

bash:
	ln -fsn $(here)/bash_profile $(HOME)/.bash_profile
	ln -fsn $(here)/bashrc $(HOME)/.bashrc

keylayout:
	ln -fsn $(here)/usaswe /usr/share/X11/xkb/symbols/usaswe

openbox:
	mkdir -p $(HOME)/.config/openbox
	ln -fsn $(here)/openbox/rc.xml $(HOME)/.config/openbox/rc.xml
	ln -fsn $(here)/openbox/autostart $(HOME)/.config/openbox/autostart

scripts:
	ln -fsn $(here)/scripts $(HOME)/scripts

slim:
	sudo ln -fsn $(here)/slim/images/background.png /usr/share/slim/themes/slim-archlinux-default/background.png
	sudo ln -fsn $(here)/slim/images/panel.png /usr/share/slim/themes/slim-archlinux-default/panel.png
	sudo ln -fsn $(here)/slim/slim.theme /usr/share/slim/themes/slim-archlinux-default/slim.theme

xbindkeys:
	ln -fsn $(here)/xbindkeysrc $(HOME)/.xbindkeysrc

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc

xmonad:
	ln -fsn $(here)/xmonad.hs $(HOME)/.xmonad/xmonad.hs

zsh:
	ln -fsn $(here)/zprofile $(HOME)/.zprofile
	ln -fsn $(here)/zshrc $(HOME)/.zshrc

.PHONY: bar bash keylayout openbox scripts slim xbindkeys xinitrc xmonad zsh
