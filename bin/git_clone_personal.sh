#!/bin/bash

if [ -z "$1" ] || [ "${1#git@github.com}" == "$1" ] ; then
  echo "SSH url to clone is required."
  exit 1
fi

if [ -z "$PERSONAL_GITHUB_SSH_ADDRESS" ]; then
  echo '$PERSONAL_GITHUB_SSH_ADDRESS required'
  exit 1
fi

ADDRESS="${1/git@github.com/$PERSONAL_GITHUB_SSH_ADDRESS}"

if [ -z "$PERSONAL_GITHUB_EMAIL" ]; then
  echo '$PERSONAL_GITHUB_EMAIL required'
  exit 1
fi

if [ -z "$PERSONAL_GITHUB_USER" ]; then
  echo '$PERSONAL_GITHUB_USER required'
  exit 1
fi

REPO_GIT="${ADDRESS##*\/}"
REPO_DIR="${REPO_GIT%.git}"

git clone "$ADDRESS"
cd "$REPO_DIR"
git config user.name "$PERSONAL_GITHUB_USER"
git config user.email "$PERSONAL_GITHUB_EMAIL"

