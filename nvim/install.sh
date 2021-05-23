#!/usr/bin/env bash
set -euf -o pipefail

linkConfig() {
  local -r configDir="$(nvim "+echo stdpath('config')" "+qall" --headless 2>&1)"
  mkdir -p "$(dirname "$configDir")"
  ln -s ~/.nvim "$configDir"
}

installDependencies() {
  rustup component add rls rust-analysis rust-src rustfmt \
    && echo "Installed rust dependencies"
}

installPlugins() {
  nvim "+PlugInstall" "+qall" && echo "Installed Plugins" || echo "Could not install plugins"
  local -r cocs=('sh' 'clangd' 'rust-analyzer' 'go' 'tsserver' 'css' 'html' 'json' 'pyright' 'explorer')
  for coc in "${cocs[@]}"; do
    nvim "+CocInstall coc-$coc" "+qall" \
      && echo "Installed coc-$coc" \
      || echo "Could not install coc-$coc"
  done
}

linkConfig
installDependencies
installPlugins
