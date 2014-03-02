here := $(shell pwd)

help:
	@echo "Select a target"

all: xinitrc

xinitrc:
	ln -fsn $(here)/xinitrc $(HOME)/.xinitrc
.PHONY: xinitrc 
