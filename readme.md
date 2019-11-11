# Dotfiles

My [dotfiles](https://dotfiles.github.io/).

**Warning:** dotfiles tested on:
- [Ubuntu 18.04](http://www.ubuntu.com/)
- [macOS Mojave 10.14](https://www.apple.com/lae/macos/mojave/)

## Installation

* If this is fresh system setup I recommend running [`./init.sh`](#initialization)
* Installation is interactive so don't be afraid of your local dotfiles
* All overridden files are backed up in `~/.dotfiles.bak` directory

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

Initialization script installs packages and applies OS configuration changes I use my machines.

To run the initialization execute:

```
./init.sh SYSTEM_NAME
```

SYSTEM_NAME can be one of: ubuntu, ubuntu-server, macos. See [_init](./_init_) for details.


## Details

- [bash](./bash)
- [zsh](./zsh)
- [tmux](./tmux)
- [git](./git)
- [vim](./vim)
- [gradle](./gradle)

## Credits

Inspiration and code was taken from many sources, including:

* [Mathias Bynens'](https://github.com/mathiasbynens)
  [dotfiles](https://github.com/mathiasbynens/dotfiles)
* [Cătălin Mariș'](https://github.com/alrra)
  [dotfiles](https://github.com/alrra/dotfiles)
* [Mark H. Nichols](https://github.com/zanshin)
  [dotfiles](http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/)

## License

[MIT](LICENSE)© Paweł‚ Mendelski
XXX
