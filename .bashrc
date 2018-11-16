
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


##########################
#  SOURCE GLOBAL BASHRC  #
##########################

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


################
#  SET EDITOR  #
################

export EDITOR="vim"


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

