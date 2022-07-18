#!/bin/bash

function help() {
  echo "$(basename $0) [options]"
  echo "-h/--help             This help message"
  echo "-d/--descending       Output commits in ascending order"
  echo "-s/--shas             Output commit SHAs only"
  echo "-m/--messages         Output commit messages only"
  echo "-o/--one-line         Output commits as one line: <commit> <title>"
  echo "-b/--branch <branch>  Specify the branch to diff from directly rather than interactively"
}

BRANCH=""
SHAS_ONLY=0
MESSAGES_ONLY=0
ONE_LINE=0
ASCENDING_OPT="--reverse"

while [ -n "$1" ]; do
  case "$1" in
    # output the help info
    -h|--help)
      help
      exit 0
      ;;

    # ascending order
    -d|--descending)
      ASCENDING_OPT=""
      ;;

    # shas only
    -s|--shas)
      SHAS_ONLY=1
      ;;

    # messages only
    -m|--messages)
      MESSAGES_ONLY=1
      ;;

    # one line
    -o|--one-line)
      ONE_LINE=1
      ;;

    # list functions you can call
    -b|--branch)
      shift
      BRANCH="$1"
      ;;

    # bad flag
    *)
      echo "Bad option: [$1]"
      help
      exit 1
      ;;
  esac

  shift
done

if [ -z "$BRANCH" ]; then
  read -p "Show commits since the following branch [main]:" BRANCH
  if [ -z "$BRANCH" ]; then
    BRANCH=main
  fi
fi

if [ "$SHAS_ONLY" == "1" ]; then
  git log $ASCENDING_OPT ${BRANCH}.. --pretty=format:%h
elif [ "$MESSAGES_ONLY" == "1" ]; then
  git log $ASCENDING_OPT ${BRANCH}.. --pretty=format:%s
elif [ "$ONE_LINE" == "1" ]; then
  git log $ASCENDING_OPT ${BRANCH}.. --pretty=format:"%h %s"
else
  git log $ASCENDING_OPT ${BRANCH}..
fi

