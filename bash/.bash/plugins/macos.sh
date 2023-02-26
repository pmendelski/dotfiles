#!/usr/bin/env bash

function macos-rm-ds-store {
  find . -name ".DS_Store" -type f -delete
}
