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

function git_branch_exists_remote() {
  [ -z "$(git rev-parse --abbrev-ref @{u} 2>&1 1>/dev/null)" ] && echo "true" || echo "false"
}

function git_check_if_in_sync() {
  local full_branch="" # need to pre-declare so $? is the result of the command rather than local
  full_branch=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "local_only"
  else
    local local_sha="$(git rev-parse HEAD 2>/dev/null)"

    local spaced_branch=$(echo "$full_branch" | sed 's#/# #g')
    local remote_sha_and_ref=$(git ls-remote $spaced_branch 2>/dev/null)
    local remote_sha=$(echo "$remote_sha_and_ref" | cut -f1)
    # typeset -p local_sha full_branch spaced_branch remote_sha_and_ref remote_sha

    if [ "$local_sha" = "$remote_sha" ]; then
      echo "synced"
    else
      echo "unsynced"
    fi
  fi
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
#  prompt+="\$(ps1_getgitsynced)"                # Red/Yellow/Green:    Git synced (trailing : existance base on the function).
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

function ps1_getgitsynced() {
  if [ -n "$(git_repo)" ]; then
    local sync_status=`git_check_if_in_sync`
    if [ "$sync_status" = "local_only" ]; then
      echo "${C_ECHO_YELLOW}…$C_ECHO_RESET:"
    elif [ "$sync_status" = "synced" ]; then
      echo "${C_ECHO_GREEN}≡$C_ECHO_RESET:"
    else
      echo "${C_ECHO_RED}≠$C_ECHO_RESET:"
    fi
  fi
}

