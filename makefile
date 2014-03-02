here := $(shell pwd)

help:
	@echo "Select a target"

all: xinitrc

openbox:
	ln -fsn $(here)/rc.xml $(HOME)/.config/openbox/rc.xml

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc
.PHONY: xinitrc 
