#!/bin/bash

# this fails if it goes to root
find_upward() {
  local filename="$1"
  local path=$(pwd)

  # keep knocking off a directory at a time until the filename is found or path is empty
  while [[ "$path" != "" && ! -e "$path/$filename" ]]; do
    path=${path%/*}
  done

  # empty path var == file not found
  if [ -z "$path" ]; then
    echo ""
    return 1
  fi

  echo "$path/$filename"
}

if [ -z "$1" ]; then
  echo "You must specify a filename"
  return 1
fi

find_upward "$1"
