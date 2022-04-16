#!/usr/bin/env bash

if [ -e "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -e "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env";
fi

function rust-update() {
  # rustup component remove rls rust-analysis rust-src rustfmt clippy
  echo "Updating rust"
  # rustup default nightly
  rustup update && echo "Updated rust"
  rustc --version
  echo ""

  echo "Updating rust analyzer"
  rustup +nightly component remove rust-analyzer-preview \
    && echo "Removed previous rust-analyzer" \
    || echo "No previous version of rust-analyzer"
  rustup +nightly component add rust-analyzer-preview \
    && echo "Installed new rust-analyzer" \
    || echo "Could not install new version of rust-analyzer"
  rust-analyzer --version

  # rustup component add rls rust-analysis rust-src rustfmt clippy
}
