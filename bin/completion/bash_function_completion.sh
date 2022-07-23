#!/bin/bash

_bash_function_completion()
{
  file_called="${COMP_WORDS[0]}"

  # make completion work with tilde, expand to home
  full_file=$(echo "$file_called" | sed -E "s|^\~|${HOME}|")

  grep_cmd="grep"
  sed_cmd="sed"

  if [ "$ISMAC" == "1" ]; then
    grep_cmd="ggrep" # brew install grep
    sed_cmd="gsed" # brew install gnu-sed
  fi

  # get function names of these styles: 'function foo {' or 'foo() {'
  function_names=`$grep_cmd -oP 'function.*{$|.*\(\) *{$' "$full_file" |$sed_cmd -E 's/(function\s+)|(\s+\{)|(\(.*)//g'`

  COMPREPLY=($(compgen -W "$function_names" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

# To make files autocomplete, put a line like this somewhere it will be sourced (and source this file after)
# export BASH_FUNCTION_COMPLETION_FILES+=("filename.sh")

complete -F _bash_function_completion -o default "${BASH_FUNCTION_COMPLETION_FILES[@]}"

