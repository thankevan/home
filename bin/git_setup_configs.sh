#!/bin/bash

_check_for_yes_no() {
	local question="$1"
  local default="$2"

	local yes_no_response=""

  if [ -z "$default" ]; then
    question="$question (y/n): "
  elif [ "$default" = "y" ]; then
    question="$question ([y]/n): "
  elif [ "$default" = "n" ]; then
    question="$question (y/[n]): "
  else
    echo "Bad default for _check_for_yes_no()"
    exit 1
  fi

	until [ "$yes_no_response" = "y" ] || [ "$yes_no_response" = "n" ]; do
		read -p "$question" yes_no_response
    if [ -z "$yes_no_response" ] && [ -n "$default" ]; then
      yes_no_response="$default"
    fi
	done

  [ "$yes_no_response" = "y" ]
  return $?
}

_git_config_question_and_apply() {
  local config="$1"
  local value="$2"

  if [ -z "$config" ] || [ -z "$value" ]; then
    echo "Config and value must be specified to _git_config_question_and_apply()"
    exit 1
  fi

  if _check_for_yes_no "Turn on $config?" "y"; then
    git config --global $config $value
  fi
}

## HELP

# autocorrect - in 5.0 seconds
_git_config_question_and_apply "help.autocorrect" 50


## PULL

# use rebase for pull strategy
_git_config_question_and_apply "pull.rebase" true


## REBASE

# do git pull --rebase --autostash by default
_git_config_question_and_apply "rebase.autoStash" true


## RERERE

# git rerere
_git_config_question_and_apply "rerere.enabled" true
_git_config_question_and_apply "rerere.autoUpdate" true


## PUSH

# automatically set upstream but still needs >git push -u on the first push, might be unnecessary with the following config.
_git_config_question_and_apply "push.default" "current"

# autoset remote branch
_git_config_question_and_apply "push.autoSetupRemote" true


## STATUS

# Show stash count
_git_config_question_and_apply "status.showStash" true


## SUBMODULES

# default to recursive submodule commands
_git_config_question_and_apply "submodule.recurse" true

