#!/usr/bin/env bash
set -euf -o pipefail

if command -v rustup &>/dev/null; then
  rustup component add rls rust-analysis rust-src rustfmt clippy
  rustup +nightly component add rust-analyzer-preview
else
  echo "Missing command: rustup" >&2
  echo "Skipped: rust-analyzer, rls and more..."
fi
