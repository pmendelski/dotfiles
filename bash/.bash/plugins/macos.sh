#!/usr/bin/env bash

function macos-rm-ds-store {
  find . -name ".DS_Store" -type f -delete
}

function macos-rm-ds-store-home {
  find "$HOME" -name ".DS_Store" -type f -delete
}
