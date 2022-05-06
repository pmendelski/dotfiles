#!/usr/bin/env bash
set -e

./packages/system.sh
./packages/system-gui.sh
./packages/media.sh
./packages/net.sh
./packages/theme.sh

