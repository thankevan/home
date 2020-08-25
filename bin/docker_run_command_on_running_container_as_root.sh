#!/bin/bash

container="$1"
command="${@:2}" # from 2nd param on

docker exec -it --user root $container $command

