alias e="vim"
alias ec="emacsclient -nw"
export EDITOR="vim"
export WORKON_HOME=~/Envs
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh

if [ -f ~/.ps1 ]; then
	. ~/.ps1
fi

if [ -f ~/.Xresources ]; then
	xrdb -merge ~/.Xresources
fi
