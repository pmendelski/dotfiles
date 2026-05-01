# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical Constraints

### Security — Public Repository
This repo is public on GitHub. **Never commit personal or sensitive information**: no real names, email addresses, API keys, tokens, hostnames, IP addresses, or anything that identifies specific machines or accounts. Machine-specific config belongs in the local override files (see [Local Overrides](#local-overrides--extension-points)), not in this repo.

### Cross-Environment Compatibility
These dotfiles run on **macOS, Ubuntu, and lightweight Linux distros** (VPS, Raspberry Pi). Shell scripts must not assume a specific OS or the presence of non-POSIX tools. Use `systype` detection (`_sysinit/`, `bash/.bash/plugins/systype.sh`) when branching on OS.

### Shell Compatibility
The primary shell is **zsh**, but everything must also load cleanly in **bash**. Zsh-only features (autosuggestions, syntax highlighting, advanced completions) are acceptable, but the bash layer must remain functional on its own. Never put zsh syntax in files sourced by bash.

## Repository Purpose

Personal dotfiles managed via symlinks. All config files live here and are symlinked into `$HOME` by `install.sh`.

## Common Commands

```sh
# Install/update dotfiles (symlinks everything to $HOME, safe to re-run)
./install.sh

# Update dependencies without re-symlinking
./install.sh -u

# Dry run (preview what would happen)
./install.sh -r

# Validate shell scripts (ShellCheck) and Lua files (Luacheck)
./check.sh

# Initialize OS packages and system config (macos | ubuntu | ubuntu-server | rpi)
./sysinit.sh macos
```

## Architecture

### Installation Model

`install.sh` is the single entry point. For each top-level directory (`bash/`, `zsh/`, `nvim/`, `tmux/`, `git/`, `common/`), it:
1. Runs that directory's `install.sh` (tool-specific setup, cloning deps)
2. Symlinks all `.*` files to `$HOME`
3. Backs up any pre-existing conflicts to `~/.dotfiles.bak`

Each component is self-contained with its own `install.sh` and sometimes `update.sh`.

### Shell Config Layering

**Bash is the foundation; Zsh extends it.** `zsh/.zsh/index.zsh` sources bash config first, then loads zsh-specific additions.

- **Bash entry point:** `bash/.bashrc` → loads `~/.bash/index.sh` → sources `lib/`, then `plugins/`, then `prompts/`
- **Zsh entry point:** `zsh/.zshrc` → loads `~/.zsh/index.zsh`
- **Plugin system:** `bash/.bash/plugins/` has ~33 optional scripts (fzf, git, kubectl, gcloud, etc.). Control via `bash_plugins` variable.
- **Zsh deps:** External plugins (zsh-autosuggestions, zsh-syntax-highlighting, etc.) are git-cloned into `~/.zsh/deps/` by `zsh/install.sh`

### Local Overrides / Extension Points

Do not modify the main dotfiles for machine-specific config. Use:
- `~/.bash_exports`, `~/.bash_aliases`, `~/.bash_functions` — per-machine bash overrides
- `~/.zsh_exports`, `~/.zsh_aliases`, `~/.zsh_functions` — per-machine zsh overrides
- `~/.dotfiles-ext/bash/` and `~/.dotfiles-ext/zsh/` — additional plugin directories
- `~/.zshrc_local` / `~/.initrc_local` — arbitrary local init code

### Key Components

| Directory | Purpose |
|-----------|---------|
| `bash/` | Bash config: `lib/` (core), `plugins/` (optional tools), `prompts/` (PS1) |
| `zsh/` | Zsh config extending bash; `deps/` for third-party plugins |
| `nvim/` | Neovim config using LazyVim framework |
| `tmux/` | Tmux config; prefix is `C-a`; plugins in `deps/` |
| `git/` | `.gitconfig_base` + `.gitconfig_aliases` (extensive alias set) |
| `common/` | Configs for bat, ranger, ghostty, lazygit, fd, ripgrep |
| `claude/` | Claude Code hooks and custom slash commands |
| `_sysinit/` | OS-specific package installation scripts |

### Code Quality

`check.sh` runs:
- **ShellCheck** on all `.sh` files (excluding `deps/`, `plugins/` third-party dirs, `tmp/`)
- **Luacheck** on all `.lua` files with globals `vim`, `LazyVim`, `Snacks` allowed

### Coding Conventions

From `.editorconfig`:
- Default: 2-space indentation, LF line endings, UTF-8
- Go, Lua, Makefiles, `.gitmodules`: tabs
