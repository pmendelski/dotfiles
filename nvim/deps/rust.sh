#!/usr/bin/env bash
set -euf -o pipefail

installRustAnalyzer() {
  local os="unknown-linux-gnu"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="apple-darwin"
  fi
  local arch="x86_64"
  if [ "$(uname -m)" == "arm64" ]; then
    arch="aarch64"
  fi
  mkdir -p ~/.local/bin
  curl -fL https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-${arch}-${os}.gz |
    gunzip -c - >~/.local/bin/rust-analyzer
  chmod +x ~/.local/bin/rust-analyzer
}

if command -v rustup &>/dev/null; then
  rustup component add rls rust-analysis rust-src rustfmt clippy
  rustup update nightly
  installRustAnalyzer
else
  echo "Missing command: rustup" >&2
  echo "Skipped: rust-analyzer, rls and more..."
  exit 1
fi
