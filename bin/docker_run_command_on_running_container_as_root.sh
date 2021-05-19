#!/bin/bash

if [ "$2" == "" ]; then
  echo "Proper use: $0 <container name> <command>"
  exit 1
fi

container="$1"
command="${@:2}" # from 2nd param on

docker exec -it --user root $container $command

