# Zsh

Zsh configuration extends [bash configuration](../bash/readme.md).

## Structure

```
zsh
├── .zsh
│   ├── completions # Zsh completions
│   ├── deps        # External dependencies
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
All local bash/zsh configuration files like `.zsh_exports`, `.zsh_prompt`, `.zsh_aliases`, `.zsh_functions`
are imported during initialization.

## Prompt

Switch prompts with `zshChangePrompt "promptName"`.
To change the prompt permanently just change a `ZSH_PROMPT` variable in `.zsh_exports` and reload terminal.

Available prompts:
- `flexi` - It's the default prompt ([details](../bash/.bash/prompts/flexi-prompt)).
- `basic` - Typical ubuntu prompt.
