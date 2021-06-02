#!/bin/bash

_git_checkout_completion()
{
  COMPREPLY=($(compgen -W "$(git branch --format='%(refname:short)')" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _git_checkout_completion git_checkout gco

git_checkout()
{
  git checkout $1
}

alias gco=git_checkout

