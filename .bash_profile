#!/bin/bash

source ~/.bash_colors
source ~/.bash_functions
source ~/.bash_aliases 
source ~/.bash_ascii_art
source ~/.bash_private
source ~/git-completion.bash
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspaces/wf
alias venv='source /usr/local/bin/virtualenvwrapper.sh'

# ---
# Terminal
# ---
export PS1='\[\e[38;5;238m\][\@ \D{%m/%d/%Y}] \[\e[38;5;33m\]\u@\h \e[38;5;31m\]\w\[\e[0m\]\[\e[38;5;241m\]$(parse_git_branch)\[\e[38;5;250m\] \n$ \[\e[0m\]'

export CLICOLOR=1

export LSCOLORS=gxfxcxdxbxegedabagacad

alias ls='ls -GFh'

# --------
# On Start
# --------
echo -e "$WORKIVA_W"
echo -e "${GREY}
----------------------------------------------------------------------------------------
"
fortune
echo -e "
----------------------------------------------------------------------------------------
${NC}"

#fortune | cowsay -f tux
