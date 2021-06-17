#!/bin/bash

# prevent commiting directly to default branch
# link as pre-commit in .git/hooks or add executing this in that file

branch="$(git rev-parse --abbrev-ref HEAD)"
default_branch="$(git_get_default_branch_name.sh)"

if [ "$branch" = "$default_branch" ]; then
  echo "You can't commit directly to the default branch"
  exit 1
fi

