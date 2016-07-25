# Source
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f ~/.ps1 ] && source ~/.ps1
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# Aliases
alias e="vim"
alias ec="emacsclient -nw"

# Exports
export EDITOR="vim"
export WORKON_HOME=~/Envs

# Virtualenv
mkdir -p $WORKON_HOME
