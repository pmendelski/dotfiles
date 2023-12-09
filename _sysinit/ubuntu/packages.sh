#!/usr/bin/env bash
set -euf -o pipefail

./packages/system.sh
./packages/lang.sh
./packages/cloud.sh
./packages/docker.sh
./packages/system-gui.sh
./packages/media.sh
./packages/net.sh
./packages/theme.sh
