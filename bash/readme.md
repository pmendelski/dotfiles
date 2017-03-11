# Bash

## Structure
```
bash
├── .bash
│   ├── lib         # Basic bash configuration
│   ├── plugins     # Pluggable scripts
│   ├── prompts     # Prompts configuration
│   ├── tmp         # All bash temporary files
│   ├── util        # Some utilities to be sourced by other scripts
│   ├── exports.sh  # Basic exports
│   └── index.sh    # Entry point
├── .bash_logout    # Actions on bash logout
├── .bash_profile   # Just sources `~/.bashrc` for login shell
├── .bashrc         # Contains bash configuration
├── .hushlogin      # Disables session login notice (see `man login`)
├── .inputrc        # Config for all input. Contains keybindings and settings.
├── .lessfilter     # Config for `less` command
└── .wgetrc         # Config for `wget` command
```

All files and directories in `bash` folder are symlinked to `$HOME`.

## Local configuration files

All local bash configuration files like `.bash_exports`, `.bash_prompt`, `.bash_aliases`, `.bash_functions`
are imported during initialization.

## Plugins

Plugins are just pluggable bash scripts, imported during initialization.
You may activate them or disable them using `bash_plugins` variables.

Example:
- `bash_plugins=""` - loads all plugins
- `bash_plugins=(!less)` - loads all plugins except `less`
- `bash_plugins=(jvm mvn-color)` - loads only `jvm` and `mvn-color`

## Prompt

### Prompt setup

To change the prompt permanently just change a `BASH_PROMPT` variable in `.bash_exports` to a different one and reload terminal.

Executing the command `bashChangePrompt "promptName"` will apply changes immediately but will not be permanent.

### Available prompts

- `flexi` - It is the default prompt ([details](./.bash/prompts/flexi/readme.md)).
- `basic` - Basic ubuntu prompt.
