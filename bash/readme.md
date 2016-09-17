# Dotfiles / BASH

## Bash startup files loading order

### Login Shell Startup Files:

1. `/etc/profile`
2. `~/.bash_profile` OR `~/.bash_login` OR `~/.profile` (~/.bash_profile sources ~/.bashrc)
3. `~/.bash_logout`

### Non-Login Shell Startup Files:

1. `/etc/bash.bashrc`
2. `~/.bashrc`

## Structure

```
.dotfiles
├── .bash
│   ├── config      # Basic bash configuration
│   ├── func        # Sourced functions
│   ├── plugins     # Pluggable bash extensions
│   ├── prompts     # Prompts configuration
│   ├── scripts     # Custom scipts addded to path
│   ├── tmp         # All bash temporary files
│   ├── util        # Some utils to be sourced by other scripts
│   ├── aliases.sh  # Bash aliases
│   ├── exports.sh  # Bash exports
│   └── index.sh    # Entry point for advanced bash config
├── .bash_logout    # Actions on bash logout
├── .bash_profile   # Just sources `~/.bashrc` for login shell
├── .bashrc         # Contains bash configuration
├── .hushlogin      # Disables session login notice (see `man login`)
├── .inputrc        # Config for all input. Contains keybindings and settings.
├── .lessfilter     # Config for `less` command
└── .wgetrc         # Config for `wget` command
```

## Local configuration files

All bash configuration files like `.bash_exports`, `.bash_prompt`, `.bash_aliases`, `.bash_functions`
may have their local equivalents with suffix `_local`.

For example in order to add you custom alias just create file `~/.bash_aliases_local` and define your alias.

## Plugins

Plugins are just pluggable bash extensions, configurations and commands.
You may activate them or disable them using `bash_plugins` variable.

Example:
- `bash_plugins=""` - loads all plugins
- `bash_plugins=(!less)` - loads all plugins except less
- `bash_plugins=(jvm mvn-color)` - enables jvm, mvn-color

# Prompt

By default the **usd prompt** is being used. It's a simplified version of the [pure prompt](https://github.com/sindresorhus/pure) made for bash shell.

**Usd Prompt**

If you want to change the prompt just change the variable `BASH_PROMPT` to different one.
