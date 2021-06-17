#!/bin/bash

branch="$(git rev-parse --abbrev-ref HEAD)"
default_branch="$(git_get_default_branch_name.sh)"

if ! [ "$branch" = "$default_branch" ]; then
  git checkout $default_branch
fi

git_cleanup_local.sh

git fetch -p

