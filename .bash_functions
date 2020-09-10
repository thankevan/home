#!/bin/bash

#############################
#  COLORS (SET IN .bashrc)  #
#############################

function showcolors() {
  echo "${C_ECHO_BLACK}BLACK${C_ECHO_RESET}"
  echo "${C_ECHO_RED}RED${C_ECHO_RESET}"
  echo "${C_ECHO_GREEN}GREEN${C_ECHO_RESET}"
  echo "${C_ECHO_YELLOW}YELLOW${C_ECHO_RESET}"
  echo "${C_ECHO_BLUE}BLUE${C_ECHO_RESET}"
  echo "${C_ECHO_MAGENTA}MAGENTA${C_ECHO_RESET}"
  echo "${C_ECHO_CYAN}CYAN${C_ECHO_RESET}"
  echo "${C_ECHO_WHITE}WHITE${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_BLACK}BOLD_BLACK${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_RED}BOLD_RED${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_GREEN}BOLD_GREEN${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_YELLOW}BOLD_YELLOW${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_BLUE}BOLD_BLUE${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_MAGENTA}BOLD_MAGENTA${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_CYAN}BOLD_CYAN${C_ECHO_RESET}"
  echo "${C_ECHO_BOLD_WHITE}BOLD_WHITE${C_ECHO_RESET}"
}


##########
#  GREP  #
##########

function rgrep() {
  grep -rn --color="auto" "$@" *
}

function rgrepi() {
  grep -rni --color="auto" "$@" *
}


#########
#  AWK  #
#########

function getcolumn() {
  awk "{print \$$1}"
}

function addcolumn() {
  awk "{SUM += \$$1} END {print SUM}"
}


#########
#  GIT  #
#########


function git_curbranch() {
  #git branch 2>/dev/null |grep '^\*'|awk '{print $2}'
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function git_repo() {
  basename -s ".git" `git config --get remote.origin.url` 2>/dev/null
}


####################
#  PROMPT HELPERS  #
####################

function ps1_myprompt() {
  #ENV_PS_COLOR (and other colors are set in .bashrc)
  #Escaping the function \$() is for when the function needs to be re-called for every new prompt.

  # PS1 seems to be a bit finicky about how/when to use $C_ECHO_RESET vs $C_RESET,
  # non-root is working correctly now, will verify root next time I'm able.

  local prompt=""
  prompt+="$ENV_PS_COLOR$(ps1_getwrap)"         # Env Color:    Prompt top line wrapper based on whether user is root.
  prompt+="$C_BOLD_YELLOW\D{%I:%M%P}$C_RESET:"  # Yellow:       The time.
  prompt+="$(ps1_getuser)"                      # RED/GREEN:    Username with color based on whether user is root.
  prompt+="$C_BOLD_GREEN@\h$C_RESET:"           # Bold Green:   @Machine Name
  prompt+="\$(ps1_getgitrepo)"                  # Bold Magenta: Git repo (trailing : existance base on the function).
  prompt+="\$(ps1_getgitbranch)"                # Magenta:      Git branch (trailing : existance base on the function).
  prompt+="$C_CYAN\w"                           # Cyan:         Path
  prompt+="$ENV_PS_COLOR$(ps1_getwrap)"         # Env Color:    Prompt top line wrapper based on whether user is root.
  prompt+="\n"                                  #               Newline to give the path space without interfering.
  prompt+="$(ps1_getpromptchar) "               # Red/Normal:   Final char and color based on whether the user is root.
  echo "$prompt"
}

function ps1_getwrap() {
  if [ "$USER" == "root" ]; then
    echo "@@@@@@@@@@"
  else
    echo "==="
  fi
}

function ps1_getuser() {
  if [ "$USER" == "root" ]; then
    echo "$C_ECHO_BOLD_RED$USER$C_RESET"
  else
    echo "$C_ECHO_GREEN$USER$C_RESET"
  fi
}

function ps1_getpromptchar() {
  if [ "$USER" == "root" ]; then
    echo "$C_ECHO_BOLD_RED%$C_RESET"
  else
    echo "$C_RESET>"
  fi
}

function ps1_getgitbranch() {
  local branch=`git_curbranch`
  if [ -n "$branch" ]; then
    echo "$C_ECHO_MAGENTA$branch$C_ECHO_RESET:"
  fi
}

function ps1_getgitrepo() {
  local repo=`git_repo`
  if [ -n "$repo" ]; then
    echo "$C_ECHO_BOLD_MAGENTA$repo$C_ECHO_RESET:"
  fi
}

