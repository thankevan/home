#!/bin/bash

# this will open a container based on the image and put you into an interactive shell 

if [ "$1" == "" ]; then
  echo "Proper use: $0 <image name>"
  exit 1
fi

image="$1"

docker run -it $image sh


