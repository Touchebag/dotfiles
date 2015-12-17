here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p }' | egrep -v '^.PHONY' | egrep -v '^all'

all: git keylayout scripts slim xbindkeys xcompose xinitrc xmonad zsh

bash:
	ln -fsn $(here)/bash/bash_profile $(HOME)/.bash_profile
	ln -fsn $(here)/bash/bashrc $(HOME)/.bashrc

git:
	ln -fsn $(here)/git/gitconfig $(HOME)/.gitconfig
	ln -fsn $(here)/git/gitignore $(HOME)/.gitignore

keylayout:
	sudo ln -fsn $(here)/keylayouts/usaswe /usr/share/X11/xkb/symbols/usaswe
	sudo ln -fsn $(here)/keylayouts/usaswe_swappednumbers /usr/share/X11/xkb/symbols/usaswe_swappednumbers
	sudo ln -fsn $(here)/keylayouts/dvpswe /usr/share/X11/xkb/symbols/dvpswe

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
	sudo ln -fsn $(here)/slim/slim.conf /etc/slim.conf
	sudo ln -fsn $(here)/slim/slimlock.conf /etc/slimlock.conf

xbindkeys:
	ln -fsn $(here)/xbindkeysrc $(HOME)/.xbindkeysrc

xcompose:
	ln -fsn $(here)/xcompose $(HOME)/.XCompose

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc

xmonad:
	mkdir -p $(HOME)/.xmonad
	ln -fsn $(here)/xmonad.hs $(HOME)/.xmonad/xmonad.hs

xresources:
	ln -fsn $(here)/Xresources $(HOME)/.Xresources

zsh:
	ln -fsn $(here)/zsh/zprofile $(HOME)/.zprofile
	ln -fsn $(here)/zsh/zshrc $(HOME)/.zshrc

.PHONY: bash git keylayout openbox scripts slim xbindkeys xcompose xinitrc xmonad zsh
