#!/bin/sh

# prevent commiting directly to master
# link as pre-commit in .git/hooks or add executing this in that file

branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$branch" = "master" ]; then
  echo "You can't commit directly to master branch"
  exit 1
fi

