# Dotfiles

My [dotfiles](https://dotfiles.github.io/).

**Warning:** dotfiles tested on:
- [Ubuntu 22.04](http://www.ubuntu.com/)
- [macOS Ventura 13.2.1](https://www.apple.com/lae/macos/ventura/)

## Installation

Run [`./init.sh`](#initialization).
Installation is interactive so don't be afraid of your local dotfiles.
All overridden files are backed up in `~/.dotfiles.bak`.

```sh
cd ~
git clone git@github.com:pmendelski/dotfiles.git .dotfiles
cd .dotfiles
./install.sh
```

For more options please see:
```sh
./install.sh -h
```

## Initialization

Initialization script installs packages and applies OS configuration.

Run:
```
./init.sh SYSTEM_NAME
```
SYSTEM_NAME can be one of: ubuntu, ubuntu-server, macos. See [_init](./_init) for details.
