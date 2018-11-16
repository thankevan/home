#!/bin/bash

find . -iname "*$1*" | grep -v '\.git' | grep -v '\.svn' | grep --color='always' -i "$1"

