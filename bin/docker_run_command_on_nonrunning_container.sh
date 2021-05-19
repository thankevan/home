#!/bin/bash

# this will also run on a running container but will bring up all dependencies

if [ "$2" == "" ]; then
  echo "Proper use: $0 <container name> <command>"
  exit 1
fi

container="$1"
command="${@:2}" # from 2nd param on

docker-compose run $container $command

