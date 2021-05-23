#!/usr/bin/env bash

fasd_cache="$HOME/.fasd-init"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init auto >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

[ -n "$BASH_VERSION" ] && _fasd_bash_hook_cmd_complete v m j o
