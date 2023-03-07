#!/bin/bash

# autocorrect - in 5.0 seconds
git config --global help.autocorrect 50

# do git pull --rebase --autostash by default
git config --global rebase.autoStash true
