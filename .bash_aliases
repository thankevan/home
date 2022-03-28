#!/bin/bash

####################
#  BASIC COMMANDS  #
####################

# Make dangerous commands interactive (Do you want to delete that file?).
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Show true (physical) path instead of symbolic links in the path.
alias cd="cd -P"
alias cd..="cd -P .."
alias cd.="cd -P .."

# Make parent dirs as necessary.
alias mkdir="mkdir -p"

# Add some ls coloring.
if [ $ISMAC == 1 ]; then
  export lscolor="-G"
else
  export lscolor="--color='auto'"
fi

alias ls="ls $lscolor"
alias sl="ls $lscolor"
alias la="ls -al $lscolor"
alias lS="ls -alSh $lscolor"


###############
#  SEARCHING  #
###############

alias ff="$HOME/bin/find_file.sh"
alias fh="history | grep --color='auto'"

alias grep="grep --color='auto'"


#########
#  VIM  #
#########

# Do vertical/horizontal splits for vim when multiple files are specified.
alias vim='vim -O'
alias vo='vim -o'


#####################
#  GUI INTERACTION  #
#####################

# Open current path in gui
if [ $ISMAC = 1 ]; then
  alias start=open
elif [ $ISCYG = 1 ]; then
  alias start=cygstart
#  alias start="/cygdrive/c/Windows/explorer.exe /e, \`cygpath -w \"\$(pwd)\"\`"
else
  alias start=nautilus
fi


########################
#  FUNCTION OVERRIDES  #
########################

alias gc="getcolumn"
alias ac="addcolumn"

