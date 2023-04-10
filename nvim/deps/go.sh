#!/usr/bin/env bash
set -euf -o pipefail

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
