#!/bin/bash

# this will also run on a running container but will bring up all dependencies

container="$1"
command="${@:2}" # from 2nd param on

docker-compose run $container $command

