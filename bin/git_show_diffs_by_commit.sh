#!/bin/bash

function help() {
  echo "$(basename $0) [options]"
  echo "-h/--help             This help message"
  echo "-d/--descending       Output commits in descending order"
  echo "-b/--branch <branch>  Specify the branch to diff from directly rather than interactively, default is main"
}

BRANCH="main"
DESCENDING=0

while [ -n "$1" ]; do
  case "$1" in
    # output the help info
    -h|--help)
      help
      exit 0
      ;;

    # ascending order
    -d|--descending)
      DESCENDING=1
      ;;

    # list functions you can call
    -b|--branch)
      shift
      if [ -z "$1" ]; then
        help
        exit 1
      fi
      BRANCH="$1"
      ;;

    # bad flag
    *)
      help
      exit 1
      ;;
  esac

  shift
done

OPTIONS="-s -b $BRANCH"
if [ "$DESCENDING" = "1" ]; then
  OPTIONS="$OPTIONS -d"
fi

for sha in `git_show_commits.sh $OPTIONS`; do
  message=`git log -n1 --pretty=format:%s $sha`

  yes_no_response="-"
  until [ "$yes_no_response" = "y" ] || [ "$yes_no_response" = "n" ]; do
    read -p "Show diff for $C_ECHO_BOLD_CYAN${sha} $C_ECHO_BOLD_MAGENTA${message}$C_ECHO_RESET ([y]/n)?" yes_no_response
    if [ -z "$yes_no_response" ]; then
      yes_no_response="y"
    fi
  done

  if [ "y" = "$yes_no_response" ]; then
    git show "$sha"
  fi
done
