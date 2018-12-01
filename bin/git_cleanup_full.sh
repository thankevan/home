#!/bin/bash

branch="$(git rev-parse --abbrev-ref HEAD)"

if ! [ "$branch" = "master" ]; then
  git checkout master
fi

git_cleanup_local.sh

git fetch -p

