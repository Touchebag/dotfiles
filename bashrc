#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'

alias cd..='cd ..'
#PS1='[\u@\h \W]\$ '
PS1='[\W]\$ '
