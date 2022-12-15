#!/bin/bash

# This script is useful for testing scenarios in git.
# It will create a file, git add it, and commit it.
# Use like git_test_commit_creator.sh A

file="$1"

if [ -z "$file" ]; then
  echo "You must specify a filename"
  return 1
fi

set +x
touch "$file"
git add "$file"
git commit -m "Add $file"

