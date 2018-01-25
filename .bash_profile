#!/bin/bash

source ~/.bash_colors
source ~/.bash_aliases 
source ~/.bash_ascii_art
if [ -d "~/.bash_functions/*" ]; then
    for f in "~/.bash_functions/*"; do
        source $f;
    done
fi
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
if [ -f ~/.bash_private ]; then
    source ~/.bash_private
fi
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
if [ -f ~/git-completion.bash ]; then
    source ~/git-completion.bash
fi

# ----------
#  Env Vars
# ----------

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspaces/wf
alias venv='source /usr/local/bin/virtualenvwrapper.sh'

# ----------
#  Terminal
# ----------
export PS1='\[\e[38;5;238m\][\@ \D{%m/%d/%Y}] \[\e[38;5;33m\]\u@\h \e[38;5;31m\]\w\[\e[0m\]\[\e[38;5;241m\]$(parse_git_branch)\[\e[38;5;250m\] \n$ \[\e[0m\]'

export CLICOLOR=1

export LSCOLORS=gxfxcxdxbxegedabagacad

alias ls='ls -GFh'

# ----------
#  On Start
# ----------
echo -e "$WORKIVA_W"
echo -e "${GREY}
----------------------------------------------------------------------------------------
"
fortune
echo -e "
----------------------------------------------------------------------------------------
${NC}"

#fortune | cowsay -f tux
