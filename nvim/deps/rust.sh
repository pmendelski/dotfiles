#!/usr/bin/env bash
set -euf -o pipefail

rustup component add rls rust-analysis rust-src rustfmt clippy
# nightly
rustup +nightly component add rust-analyzer-preview
