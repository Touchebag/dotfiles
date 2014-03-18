#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

alias cd..='cd ..'
#PS1='[\u@\h \W]\$ '
PS1='[\W]\n \$ '
