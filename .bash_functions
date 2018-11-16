
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


