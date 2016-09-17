# bash

## Structure
```
bash
├── .bash
│   ├── config      # Basic bash configuration
│   ├── func        # Sourced functions
│   ├── plugins     # Pluggable bash extensions
│   ├── prompts     # Prompts configuration
│   ├── scripts     # Custom scripts added to path
│   ├── tmp         # All bash temporary files
│   ├── util        # Some utilities to be sourced by other scripts
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

All files and directories in `bash` folder are symlinked to `$HOME` (except readme related files).

## Bash startup files [loading order](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)

Login Shell Startup Files:
```
1. /etc/profile
2. ~/.bash_profile or ~/.bash_login or ~/.profile`
3. ~/.bash_logout
```

Non-Login Shell Startup Files:
```
1. /etc/bash.bashrc
2. ~/.bashrc`
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

## Prompt


### Prompt setup

If you want to change the prompt just change the variable `BASH_PROMPT` to different one
or use command `bashChangePrompt "promptName"`. Executing the command will apply changes immediately.

Prompts:
- `flexi` - It's the default prompt ([details](#flexi-prompt)).
- `basic` - Typical ubuntu prompt.

### Flexi Prompt

**Flexi prompt** is used by default. It's a flexible prompt setup that can be easily extend using themes.

Themes can be changed using variable `FLEXI_PROMPT_THEME` or using command `flexiPromptTheme <themeName>`. Executing the command will apply changes immediately.

Themes:
- `pure` - It's the default theme. It's the default theme. Similar to [pure prompt](https://github.com/sindresorhus/pure).
- `basic` - less controversial theme.
