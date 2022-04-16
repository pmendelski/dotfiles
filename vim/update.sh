#!/usr/bin/env bash
set -euf -o pipefail

vim -c ':PlugInstall' -c 'qa!'
