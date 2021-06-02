#!/bin/bash

CONTAINER_NAME_COMPLETE_SCRIPTS=(
  docker_tail_logs_pretty.sh
  docker_rebuild_container.sh
  docker_run_command_on_nonrunning_container.sh
  docker_run_command_on_running_container.sh
  docker_run_command_on_running_container_as_root.sh
)

_container_name_completion()
{
  container_names=`docker ps --format "{{.Names}}"`

  COMPREPLY=($(compgen -W "$container_names" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

_image_name_completion()
{
  #docker images --filter "dangling=false" --format "{{.Repository}} {{.ID}}"
  image_names=`docker images --filter "dangling=false" --format "{{.Repository}}"`

  COMPREPLY=($(compgen -W "$image_names" -- "${COMP_WORDS[$COMP_CWORD]}"))
}


complete -F _container_name_completion -o default "${CONTAINER_NAME_COMPLETE_SCRIPTS[@]}"

