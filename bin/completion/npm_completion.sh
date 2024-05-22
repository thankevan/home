#!/bin/bash


# from : https://docs.npmjs.com/cli/v6/commands
_npm_secondary_commands()
{
  # replaced run-script with run (its alias)
  echo "access adduser audit bin bugs build bundle cache ci completion config dedupe deprecate dist-tag docs doctor edit explore fund help help-search hook init install install-ci-test install-test link logout ls org outdated owner pack ping prefix profile prune publish rebuild repo restart root run search shrinkwrap star stars start stop team test token uninstall unpublish update version view whoami"
}

_npm_get_scripts()
{
  if ! [ -e "$(pwd)/package.json" ]; then
    echo ""
    return
  fi

  # the -r signifies raw output written to standard output rather than a formatted JSON string with quotes
  echo "$(jq -r '.scripts|keys|join(" ")' package.json)"
}

_npm_scripts_completion()
{
  # allow colons as part of the word by removing colon from COMP_WORDBREAKS then reseting it after completion
  local oldbreaks="$COMP_WORDBREAKS"
  COMP_WORDBREAKS="$(echo "$COMP_WORDBREAKS" | sed 's/://')"
  COMPREPLY=( $(compgen -W "$(_npm_get_scripts)" -- "${COMP_WORDS[$COMP_CWORD]}") )
  COMP_WORDBREAKS="$oldbreaks"
}

_npm_multilevel_completion()
{
  local cur prev

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [ "$COMP_CWORD" = "1" ]; then
    COMPREPLY=( $(compgen -W "$(_npm_secondary_commands)" -- "$cur") )
    return 0
  elif [ "$COMP_CWORD" = "2" ]; then
    case "$prev" in
      "run")
        _npm_scripts_completion
        ;;

      *)
        ;;
    esac
  fi
}

complete -F _npm_scripts_completion npm_run nr
complete -F _npm_multilevel_completion npm

npm_run()
{
  npm run "$@"
}

alias nr=npm_run
alias npmr=npm_run

