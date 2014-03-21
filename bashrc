#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

alias cd..='cd ..'

alias gs='git status'
alias gc='git commit -am'
alias gpush='git push'
alias gpull='git pull'

#PS1='[\u@\h \W]\$ '
PS1='[\W]\n \>\>'
