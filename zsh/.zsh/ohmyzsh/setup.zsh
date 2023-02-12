#!/bin/zsh

function linkOhMyZshPlugins() {
  local -r plugins=("extract" "sudo")

  find "$HOME/.zsh/ohmyzsh" -mindepth 1 -maxdepth 1 -type l -print0 | \
    while read -r -d $'\0' plugin; do
      rm "$plugin"
    done

  for plugin in $plugins; do
    ln -s "$HOME/.zsh/deps/ohmyzsh/plugins/$plugin" "$HOME/.zsh/ohmyzsh/$plugin"
  done
}

linkOhMyZshPlugins
