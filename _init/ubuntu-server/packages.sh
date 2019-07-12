#!/usr/bin/env bashx

repository() {
  sudo add-apt-repository -y "$1"
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
