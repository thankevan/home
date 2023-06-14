#!/bin/bash

ext="$1"

if [ "$ext" = "" ]; then
  echo "The first param must be an extension."
  exit
fi

read -p "Read files like *.$1 ?"

curpath="$2"

if ! [ -d "$curpath" ]; then
  echo "The second param must be a directory."
  exit
fi

cd "$curpath"

for fullfile in *."$1"; do
  basefile=$(basename "$fullfile")
  band="${basefile%% -*}"
  if ! [ -d "$band" ]; then
    mkdir "$band"
  fi

  mv -n "$basefile" "$band"/
done



