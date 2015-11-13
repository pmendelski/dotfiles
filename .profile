#!/bin/bash
# .profile is for things that are not specifically related to Bash,
# like environment variables PATH and friends, and should be available anytime.
# For example, .profile should also be loaded when starting a graphical desktop session.

# ~/.profile: executed by the command interpreter for login shells
# see /usr/share/doc/bash/examples/startup-files for examples.

# Login Shell Strtup Files:
# 1. /etc/profile
# 2. ~/.bash_profile OR ~/.bash_login OR ~/.profile
# 3. ~/.bash_logout

# if running bash
if [ -n "$BASH_VERSION" ]; then
    [[ -s "/etc/bash.bashrc" ]] && source "/etc/bash.bashrc"
    [[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Added by WINE
export WINEARCH=win32
