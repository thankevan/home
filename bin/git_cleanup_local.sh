#!/bin/bash

branch="$(git rev-parse --abbrev-ref HEAD)"
default_branch="$(git_get_default_branch_name.sh)"

if ! [ "$branch" = "$default_branch" ]; then
  git checkout $default_branch
fi

git pull

echo ""
echo "Going to delete:"
git branch --merged | grep -v $default_branch
echo "Hit enter to continue or ^-c to cancel"
read foo

git branch -d `git branch --merged | grep -v $default_branch` 2>/dev/null

