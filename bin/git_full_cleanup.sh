#!/bin/bash

branch="$(git rev-parse --abbrev-ref HEAD)"

if ! [ "$branch" = "master" ]; then
  git checkout master
fi

git_local_cleanup.sh

git fetch -p

