#!/usr/bin/env bash

if [ -n "$BASH_VERSION" ] && command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi
