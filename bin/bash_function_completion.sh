#!/bin/bash

_bash_function_completion()
{
  file_called="${COMP_WORDS[0]}"
 
  # make completion work with tilde, expand to home
  full_file=$(echo "$file_called" | sed -E "s|^\~|${HOME}|")

  # get function names regardless of style: 'function foo {' or 'foo() {'
  function_names=`grep -oP 'function.*|.*\(\)' "$full_file" |sed -E 's/(function\s+)|(\s+\{)|(\(.*)//g'`

  COMPREPLY=($(compgen -W "$function_names" -- "${COMP_WORDS[1]}"))
}

complete -F _bash_function_completion -o default "${BASH_FUNCTION_COMPLETION_FILES[@]}"
