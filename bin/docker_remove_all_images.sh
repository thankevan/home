#!/bin/bash

# remove all images 
docker rmi $(docker images -q)



