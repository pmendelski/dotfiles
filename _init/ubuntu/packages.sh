#!/usr/bin/env bash
set -euf -o pipefail

./packages/system.sh
./packages/system-gui.sh
./packages/media.sh
./packages/net.sh
./packages/theme.sh

