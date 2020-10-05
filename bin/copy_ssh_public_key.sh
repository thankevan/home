#!/bin/bash

if [ $ISWSL == 1 ]; then
  cat ~/.ssh/id_rsa.pub | clip.exe
fi

if [ $ISCYG == 1 ]; then
  cat ~/.ssh/id_rsa.pub > /dev/clipboard
fi

if [ $ISMAC == 1 ]; then
  pbcopy < ~/.ssh/id_rsa.pub
fi

echo "ssh key copied to clipboard"

