#!/usr/bin/env bash

if [ -e "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -e "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env";
fi
