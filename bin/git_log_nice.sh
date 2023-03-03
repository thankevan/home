#!/bin/bash

git log --graph --abbrev-commit --decorate --format=format:'%C(bold cyan)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold white)%s%C(reset) - %C(yellow)%an%C(reset)%C(auto)%d%C(reset)'
