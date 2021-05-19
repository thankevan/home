#!/bin/bash

if [ "$1" == "" ]; then
  echo "Proper use: $0 <container name>"
  exit 1
fi

docker-compose build --no-cache $1

