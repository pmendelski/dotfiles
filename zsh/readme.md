# zsh

Zsh configuration extends [bash configuration](../bash/readme.md).

## ZSH startup files [loading order](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)

Login Shell Startup Files:
```
1. /etc/zshenv
2. ~/.zshenv
3. /etc/zprofile
4. ~/.zprofile
5. /etc/zshrc
6. ~/.zshrc
7. /etc/zlogin
8. ~/.zlogin
9. ~/.zlogout
10. /etc/zlogout
```

Non-Login Shell Startup Files:
```
/etc/zshenv
~/.zshenv
/etc/zshrc
~/.zshrc
```

## Structure

```
zsh
├── .zsh
│   ├── bundles     # Contains zsh bundles
│   ├── config      # Basic bash configuration
│   ├── fpath       # Directory added to zsh fpath
│   ├── plugins     # Pluggable zsh extensions
│   ├── prompts     # Prompts configuration
│   ├── tmp         # All zsh temporary files
│   ├── aliases.sh  # Zsh aliases
│   ├── exports.sh  # Zsh exports
│   └── index.sh    # Entry point for advanced bash config
└── .zshrc          # Contains zsh configuration
```

All files and directories in `zsh` folder are symlinked to `$HOME` (except readme related files).

## Local configuration files

All zsh configuration files like `.zsh_exports`, `.zsh_prompt`, `.zsh_aliases`, `.zsh_functions`
may have their local equivalents with suffix `_local`.

For example in order to add you custom alias just create file `~/.zsh_aliases_local` and define your alias.

## Plugins

Plugins are just pluggable zsh extensions, configurations and commands.
You may activate them or disable them using `zsh_plugins` variable.

Example:
- `zsh_plugins=""` - loads all plugins
- `zsh_plugins=(!less)` - loads all plugins except less
- `zsh_plugins=(jvm mvn-color)` - enables jvm, mvn-color

## Prompt

To change zsh prompt you can use the default zsh command `prompt`.

### Prompt setup

If you want to change the prompt just change the variable `ZSH_PROMPT` to different one
or use command `prompt "promptName"`. Executing the command will apply changes immediately.

Prompts:
- `flexi` - It's the default prompt ([details](../bash/readme.md#flexi-prompt)).
- `basic` - Typical ubuntu prompt.
