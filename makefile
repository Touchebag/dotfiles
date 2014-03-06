here := $(shell pwd)

help:
	@echo "Select a target"

all: openbox xinitrc 

bar:
	#$(MAKE) -C ./bar/
	#mv ./bar/bar ~/bin/
	ln -fsn $(here)/scripts/panel $(HOME)/scripts/panel

openbox:
	mkdir -p $(HOME)/.config/openbox
	ln -fsn $(here)/rc.xml $(HOME)/.config/openbox/rc.xml

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc

.PHONY: bar openbox xinitrc 
