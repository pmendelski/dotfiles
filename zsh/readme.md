# Zsh

Zsh configuration extends [bash configuration](../bash/readme.md).

## Structure

```
zsh
├── .zsh
│   ├── bundles     # Contains zsh bundles
│   ├── lib         # Basic zsh configuration
│   ├── plugins     # Pluggable zsh scripts
│   ├── prompts     # Prompts configuration
│   ├── tmp         # All zsh temporary files
│   ├── aliases.sh  # Zsh aliases
│   ├── exports.sh  # Zsh exports
│   └── index.sh    # Entry point for advanced bash config
└── .zshrc          # Contains zsh configuration
```

All files and directories in `zsh` folder are symlinked to `$HOME`.

## Local configuration files

All local bash configuration files like `.zsh_exports`, `.zsh_prompt`, `.zsh_aliases`, `.zsh_functions`
are imported during initialization.

## Plugins

Plugins are just pluggable bash scripts, imported during initialization.
You may activate them or disable them using `zsh_plugins` variables.

Example:
- `zsh_plugins=""` - loads all plugins
- `zsh_plugins=(!less)` - loads all plugins except `less`
- `zsh_plugins=(jvm mvn-color)` - loads only `jvm` and `mvn-color`

## Prompt

### Prompt setup

To change the prompt permanently just change a `ZSH_PROMPT` variable in `.zsh_exports` to a different one and reload terminal.

Executing the command `zshChangePrompt "promptName"` will apply changes immediately but will not be permanent.

### Available prompts

- `flexi` - It's the default prompt ([details](../bash/.bash/prompts/flexi-prompt)).
- `basic` - Typical ubuntu prompt.
