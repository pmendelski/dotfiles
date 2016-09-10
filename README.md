# Dotfiles

My [dotfiles](https://dotfiles.github.io/).

**Warning:** These dotfiles were tested on [Ubuntu](http://www.ubuntu.com/).

## Installation

* Installation is interactive so don't be afraid of your local dotfiles
* All overridden files are backed up in `~/.dotfiles.bak` directory

```sh
cd ~
git clone git@github.com:mendlik/dotfiles.git .dotfiles
cd .dotfiles
./install.sh
```

For more options please see:
```sh
./install.sh -h
```

## Local configuration files

All bash configuration files like `.bash_exports`, `.bash_prompt`, `.bash_aliases`, `.bash_functions`
can have their local equivalents with suffix `_local`.

For example in order to add you custom alias just create file `~/.bash_aliases_local` and define your alias.

## Acknowledgements

Inspiration and code was taken from many sources, including:

* [Mathias Bynens'](https://github.com/mathiasbynens)
  [dotfiles](https://github.com/mathiasbynens/dotfiles)
* [Cătălin Mariș'](https://github.com/alrra)
  [dotfiles](https://github.com/alrra/dotfiles)
* [Mark H. Nichols](https://github.com/zanshin)
  [dotfiles](http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/)

## License

[MIT](LICENSE) © Paweł‚ Mendelski
