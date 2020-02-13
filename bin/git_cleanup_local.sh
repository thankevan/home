#!/bin/bash

branch="$(git rev-parse --abbrev-ref HEAD)"

if ! [ "$branch" = "master" ]; then
  git checkout master
fi

git pull

echo ""
echo "Going to delete:"
git branch --merged | grep -v master
echo "Hit enter to continue or ^-c to cancel"
read foo

git branch -d `git branch --merged | grep -v master` 2>/dev/null

