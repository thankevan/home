#!/bin/bash

function help() {
  echo "$(basename $0) [options]"
  echo "-h/--help             This help message"
  echo "-d/--descending       Output commits in ascending order"
  echo "-s/--shas             Output commit SHAs only"
  echo "-m/--messages         Output commit messages only"
  echo "-o/--one-line         Output commits as one line: <commit> <title>"
  echo "-b/--branch <branch>  Specify the branch to diff from directly rather than interactively"
  echo "-a/--all-at-once      Turn off paging"
  echo "-c/--color            Use color formatting"
}

BRANCH=""
SHAS_ONLY=0
MESSAGES_ONLY=0
ONE_LINE=0
COLOR=0
ALL_AT_ONCE=0
paging=""
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

    # show commits since this specified branch
    -b|--branch)
      shift
      BRANCH="$1"
      ;;

    # use color formatting
    -c|--color)
      COLOR=1
      ;;

    # all at once (no paging)
    -a|--all-at-once)
      ALL_AT_ONCE=1
      paging="--no-pager"
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

sha="%h"
message="%s"

if [ "1" = "$COLOR" ]; then
  sha="%C(brightcyan)$sha%C(reset)"
  message="%C(brightmagenta)$message%C(reset)"
fi

if [ "$SHAS_ONLY" == "1" ]; then
  git $paging log $ASCENDING_OPT ${BRANCH}.. --pretty=format:"$sha"
elif [ "$MESSAGES_ONLY" == "1" ]; then
  git $paging log $ASCENDING_OPT ${BRANCH}.. --pretty=format:"$message"
elif [ "$ONE_LINE" == "1" ]; then
  git $paging log $ASCENDING_OPT ${BRANCH}.. --pretty=format:"$sha $message"
else
  git $paging log $ASCENDING_OPT ${BRANCH}..
fi

if [ "1" = "$ALL_AT_ONCE" ]; then
  echo
fi
