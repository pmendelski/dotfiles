#!/usr/bin/env bash

key() {
  curl -fsSL "$1" | sudo apt-key add -
}

repository() {
  sudo add-apt-repository -y "$1"
  sudo apt-get update
}

package() {
  sudo apt install -y "$1"
}

snap() {
  sudo snap install "$1"
}

# Better terminal
package zsh
package tmux
package tree

# Packages
package zip
package unzip

# Ascii art
# figlet -f slant <Some Text>
package figlet

# Build tools
package build-essential
package automake
package make
package checkinstall
package dpatch
package patchutils
package autotools-dev
package debhelper
package quilt
package fakeroot
package xutils
package lintian
package cmake
package dh-make
package libtool
package autoconf
package gcc

# GIT
repository ppa:git-core/ppa
package git

# HTTP clients
package curl
package httpie

# HTTP utils like dig
package dnsutils

# JSON parser
package jq

# Network
package apt-transport-https
package ca-certificates
package gnupg-agent
package software-properties-common

# Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "${USER}"
# Docker compose https://docs.docker.com/compose
docker_compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)"
sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
