#!/usr/bin/env bash

alias docker-kill-all='docker kill $(docker ps -q)'
alias docker-rm-all='docker rm $(docker ps -a -q)'
alias docker-rm-all-images='docker rmi $(docker images -q)'

function docker-container() {
  local -r image="${1:-Expected image name}"
  docker ps | grep "${image} " | cut -d ' ' -f1
}

function docker-inspect() {
  local -r image="${1:-Expected image name}"
  docker exec -it "$(find_docker_container "$image")" bash
}
