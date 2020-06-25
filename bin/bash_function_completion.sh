#!/bin/bash

_bash_function_completion()
{
  file_called="${COMP_WORDS[0]}"

  # make completion work with tilde, expand to home
  full_file=$(echo "$file_called" | sed -E "s|^\~|${HOME}|")

  # get function names regardless of style: 'function foo {' or 'foo() {'
  function_names=`grep -oP 'function.*|.*\(\)' "$full_file" |sed -E 's/(function\s+)|(\s+\{)|(\(.*)//g'`

  COMPREPLY=($(compgen -W "$function_names" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

# To make files autocomplete, put a line like this somewhere it will be sourced (and source this file after)
# export BASH_FUNCTION_COMPLETION_FILES+=("filename.sh")

complete -F _bash_function_completion -o default "${BASH_FUNCTION_COMPLETION_FILES[@]}"

