#!/bin/bash

# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

BASHRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#########################################
#  SOURCE LOCAL INITIAL CUSTOMIZATIONS  #
#########################################

# This will setup variables that are used in this file.

###### .PRECUSTOM OPTIONS ######
# export CODE_ENV=DEV|TEST|PROD  - Manually sets the environment.

###### .PRECUSTOM SCREEN OPTIONS ######
# export USESCREEN=1    - Activate screen.
# export USETMUX=1      - Activate tmux.
# export SYSSCREENRC=x  - Overrides .screenrc with x.

###### .PRECUSTOM BASHRC OPTIONS ######
# export QUITNOW=1      - Signifies for bashrc to stop processing.

if [ -f "$BASHRC_DIR/.bash_precustom" ]; then
  source "$BASHRC_DIR/.bash_precustom"

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

export ISBSD=0
export ISMAC=0
export ISCYG=0
export ISWSL=0

if [ "FreeBSD" = `uname` ]; then
  export ISBSD=1
fi

if [ "Darwin" = `uname` ]; then
  export ISMAC=1
fi

if [[ `uname` = CYGWIN* ]]; then
  export ISCYG=1
fi

if [[ $(uname -r) = *icrosoft* ]]; then
  export ISWSL=1
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
export PATH=$PATH:$BASHRC_DIR/bin:$BASHRC_DIR/scripts


############
#  COLORS  #
############

# Add easy to use color variables.

if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
fi

# In general, use these.
export C_RESET="\[\033[0m\]"

export C_BLACK="\[\033[0;30m\]"
export C_RED="\[\033[0;31m\]"
export C_GREEN="\[\033[0;32m\]"
export C_YELLOW="\[\033[0;33m\]"
export C_BLUE="\[\033[0;34m\]"
export C_MAGENTA="\[\033[0;35m\]"
export C_CYAN="\[\033[0;36m\]"
export C_WHITE="\[\033[0;37m\]"

export C_BOLD_BLACK="\[\033[1;30m\]"
export C_BOLD_RED="\[\033[1;31m\]"
export C_BOLD_GREEN="\[\033[1;32m\]"
export C_BOLD_YELLOW="\[\033[1;33m\]"
export C_BOLD_BLUE="\[\033[1;34m\]"
export C_BOLD_MAGENTA="\[\033[1;35m\]"
export C_BOLD_CYAN="\[\033[1;36m\]"
export C_BOLD_WHITE="\[\033[1;37m\]"

# use these inside of echo
export C_ECHO_RESET=`echo -e '\033[00m'`

export C_ECHO_BLACK=`echo -e '\033[30m'`
export C_ECHO_RED=`echo -e '\033[31m'`
export C_ECHO_GREEN=`echo -e '\033[32m'`
export C_ECHO_YELLOW=`echo -e '\033[33m'`
export C_ECHO_BLUE=`echo -e '\033[34m'`
export C_ECHO_MAGENTA=`echo -e '\033[35m'`
export C_ECHO_CYAN=`echo -e '\033[36m'`
export C_ECHO_WHITE=`echo -e '\033[37m'`

export C_ECHO_BOLD_BLACK=`echo -e '\033[1;30m'`
export C_ECHO_BOLD_RED=`echo -e '\033[1;31m'`
export C_ECHO_BOLD_GREEN=`echo -e '\033[1;32m'`
export C_ECHO_BOLD_YELLOW=`echo -e '\033[1;33m'`
export C_ECHO_BOLD_BLUE=`echo -e '\033[1;34m'`
export C_ECHO_BOLD_MAGENTA=`echo -e '\033[1;35m'`
export C_ECHO_BOLD_CYAN=`echo -e '\033[1;36m'`
export C_ECHO_BOLD_WHITE=`echo -e '\033[1;37m'`


###############################
#  CODE ENVIRONMENT COLORING  #
###############################

# This sets coloring so you are reminded what environment you are in.
# Environments are: DEV, TEST, PROD
# Coloring:
#   DEV  blue
#   TEST yellow
#   PROD red

case "$CODE_ENV" in
  "DEV" | "TEST" | "PROD" )
    ;;
  "")
    echo '$CODE_ENV is empty, setting to PROD'
    export CODE_ENV=PROD
    ;;
  *)
    echo '$CODE_ENV is typoed, resetting to PROD'
    export CODE_ENV=PROD
    ;;
esac

# Default to prod, set explicitely in .bash_precustom
if [ $CODE_ENV == 'DEV' ]; then
  export ENV_SCREEN_COLOR='bw'
  export ENV_TMUX_COLOR='bg=#0000ff,fg=white'
  export ENV_PS_COLOR=$C_ECHO_BOLD_BLUE
elif [ $CODE_ENV == 'TEST' ]; then
  export ENV_SCREEN_COLOR='yb'
  export ENV_TMUX_COLOR='bg=yellow,fg=black'
  export ENV_PS_COLOR=$C_ECHO_YELLOW
else
  export ENV_SCREEN_COLOR='rw'
  export ENV_TMUX_COLOR='bg=red,fg=white'
  export ENV_PS_COLOR=$C_ECHO_RED
fi


############
#  SCREEN  #
############

# Do some checks to see if screen should not be used.
# USESCREEN can also be set to 0 previous to this if you want to force not using screen.

# screen not installed
if [ -z "$(command -v screen)" ]; then
  export USESCREEN=0
fi

# am I already in screen?
if [ -n "$STY" ]; then
  export USESCREEN=0
fi

# no screen if I logged in directly as root
if [ "$USER" == 'root' ] && [ "$(logname 2>/dev/null)" != 'root' ]; then
  export USESCREEN=0
fi

# no screen if there's no config
if [ ! -f "$BASHRC_DIR/.screenrc" ]; then
  export USESCREEN=0
fi

# Reattach to screen if there is one available or create new session
if [ "$USESCREEN" = 1 ]; then
  screen -RR
fi


##########
#  TMUX  #
##########

# Do some checks to see if tmux should not be used.
# USETMUX can also be set to 0 previous to this if you want to force not using tmux.

# tmux not installed
if [ -z "$(command -v tmux)" ]; then
  export USETMUX=0
fi

# am I already in tmux?
if [ -n "$TMUX" ]; then
  export USETMUX=0
fi

# no tmux if I logged in directly as root
if [ "$USER" == 'root' ] && [ "$(logname 2>/dev/null)" != 'root' ]; then
  export USETMUX=0
fi

# no tmux if there's no config
if [ ! -f "$BASHRC_DIR/.tmux.conf" ]; then
  export USETMUX=1
fi

# Reattach to tmux if there is one available or create new session
if [ "$USETMUX" = 1 ]; then
  tmux_attach_flag=$(tmux ls 2>/dev/null | grep -qv 'attached)$' && echo "attach -d")
  tmux $tmux_attach_flag
fi


##########
#  TERM  #
##########

export TERM=xterm


#########################################################
#  BASH COMPLETION & SETUP FOR CUSTOM COMPLETIONS BELOW #
#########################################################
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ $ISMAC = 1 ]; then
  if [ -f "/usr/local/etc/profile.d/bash_completion.sh" ]; then
    . "/usr/local/etc/profile.d/bash_completion.sh"
  elif [ -f "/opt/homebrew/etc/profile.d/bash_completion.sh" ]; then
    . "/opt/homebrew/etc/profile.d/bash_completion.sh"
  else
    echo "You may need to: brew install bash-completion"
  fi
fi

if [ -z "$BASH_FUNCTION_COMPLETION_FILES" ]; then
  export BASH_FUNCTION_COMPLETION_FILES=()
fi

BASH_FUNCTION_COMPLETION_FILES+=("home_setup.sh")
export BASH_FUNCTION_COMPLETION_FILES


#########################
#  SOURCE MY DOT FILES  #
#########################

if [ -f "$BASHRC_DIR/.bash_functions" ]; then
  source "$BASHRC_DIR/.bash_functions"
fi

if [ -f "$BASHRC_DIR/.bash_aliases" ]; then
  source "$BASHRC_DIR/.bash_aliases"
fi


############
#  PROMPT  #
############

# ps1_myprompt is a function in .bash_functions
export PS1=`ps1_myprompt`


#################################
#  SOURCE LOCAL CUSTOMIZATIONS  #
#################################

if [ -f "$BASHRC_DIR/.bash_custom" ]; then
  # This is where I'll set my timezone so it can be based on the server location
  # export TZ='America/New_York';
  # Also, if I have machine related customizations in another folder, I'll call them from here
  source "$BASHRC_DIR/.bash_custom"
fi


##############################
#  CUSTOM COMPLETION SCRIPTS #
##############################

# for bash_function_completion.sh :
# export BASH_FUNCTION_COMPLETION_FILES+=("filename.sh")  - autocomplete functions within filename.sh
#    The above SHOULD be ok but mac bash sometimes has issues.
#    In that case update the array and then export the variable in the next line like:
#
#    BASH_FUNCTION_COMPLETION_FILES+=("filename.sh")
#    export BASH_FUNCTION_COMPLETION_FILES

for f in $BASHRC_DIR/bin/completion/*.*sh
do
  if [ -f "$f" ]; then
    source "$f"
  fi
done

