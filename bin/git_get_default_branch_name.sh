#!/bin/bash

echo $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
