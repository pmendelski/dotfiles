# Dotfiles

My [dotfiles](https://dotfiles.github.io/).

## Installation

Run [`./init.sh`](#initialization).
Installation is interactive so don't be afraid of your local dotfiles.
All overridden files are backed up in `~/.dotfiles.bak`.

```sh
git clone git@github.com:pmendelski/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

For more options please see:
```sh
./install.sh -h
```

## Initialization

Initialization script installs packages and applies OS configuration.

Run:
```
./sysinit.sh SYSTEM_NAME
```
SYSTEM_NAME can be one of: ubuntu, ubuntu-server, macos. See [_sysinit](./_sysinit) for details.

## Troubleshooting

### Missing locale

```
-bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
```
Just generate the missing locale, on Debian it's:

```
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

