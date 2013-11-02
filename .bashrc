#
# ~/.bashrc
#

[[ $- != *i* ]] && return

CYAN="\[\033[0;36m\]"
DEFAULT="\[\033[0m\]"
PS1="$CYAN[\u@\h \W]$DEFAULT "

SCRIPTS_DIR=$HOME/.scripts

function contains()
{
    haystack="$1"
    needle="$2"
    if test "${haystack#*$needle}" != "$haystack"; then
      return 0
    else
      return 1
    fi
}

function maketar()
{
  tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

if ! contains $PATH $SCRIPTS_DIR; then
  export PATH=$SCRIPTS_DIR:$PATH
fi

export EDITOR=emacs
export PAGER=most

alias ls='ls --color=auto'
alias ping='ping -c5'
alias ncdu='ncdu -r -q'
alias most='most -s -c -w'
alias mkdir='mkdir -p'
alias emacs='emacs -Q -nw -l $HOME/.emacs.d/config'



