#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vim mode
set -o vi

# Feel good alias for sudo
alias fucking='sudo'

# Dir listings
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

# Ease of use
alias cd..='cd ..'
alias y='yaourt'

# Git
alias gs='git status'
alias gc='git commit -m'
alias gac='git commit -am'
alias ga='git add'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'

#PS1='[\u@\h \W]\$ '
PS1='[\W]\n >> '
