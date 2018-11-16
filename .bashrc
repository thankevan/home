
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

#########################################
#  SOURCE LOCAL INITIAL CUSTOMIZATIONS  #
#########################################

# This will setup variables that are used in this file.

###### .PRECUSTOM BASHRC OPTIONS ######
# export QUITNOW=1      - Signifies for bashrc to stop processing.

if [ -f "${HOME}/.bash_precustom" ]; then
  source "${HOME}/.bash_precustom"

  # Don't include any other customizations.
  if [ "$QUITNOW" == "1" ]; then
      return
  fi
fi


##########################
#  SOURCE GLOBAL BASHRC  #
##########################

# Source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


################
#  SET EDITOR  #
################

export EDITOR="vim"


###############
#  OS CHECKS  #
###############

# The default is assumed to be Ubuntu.
# But, in reality, I fix issues as I notice them.

if [ "FreeBSD" = `uname` ]; then
  export ISBSD=1
else
  export ISBSD=0
fi

if [ "Darwin" = `uname` ]; then
  export ISMAC=1
else
  export ISMAC=0
fi

if [[ `uname` == CYGWIN* ]]; then
  export ISCYG=1
else
  export ISCYG=0
fi


#############
#  HISTORY  #
#############

# For setting history length.
HISTSIZE=100000
HISTFILESIZE=200000

# Don't put duplicate lines in history, also ignore commands that begin with spaces.
export HISTCONTROL=ignoreboth

# Store multiline commands in history as multiline commands.
shopt -s cmdhist

# The history list is appended to the history file when the shell exits, rather than overwriting the history file.
shopt -s histappend


############
#  WINDOW  #
############

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize


##########
#  PATH  #
##########

# User specific scripts.
# bin       is intended for scripts propogated everywhere.
# scripts   is intended for scripts just for the current machine.
export PATH=$PATH:$HOME/bin:$HOME/scripts


#####################
#  BASH COMPLETION  #
#####################

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


#########################
#  SOURCE MY DOT FILES  #
#########################

if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi


############
#  PROMPT  #
############

export PS1="\D{%I:%M%P}:$USER@\h> "


#################################
#  SOURCE LOCAL CUSTOMIZATIONS  #
#################################

if [ -f "${HOME}/.bash_custom" ]; then
  # This is where I'll set my timezone (This way the timezone can be set based on the server location.)
  # export TZ='America/New_York';
  source "${HOME}/.bash_custom"
fi

