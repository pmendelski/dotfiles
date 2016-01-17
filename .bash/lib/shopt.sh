#!/bin/bash

# Better `cd`
shopt -s nocaseglob          # Case-insensitive globbing (used in pathname expansion)
shopt -s cdspell             # Autocorrect typos in path names when using `cd`

# check the window size after each command and, if necessary,
shopt -s checkwinsize # update the values of LINES and COLUMNS.

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
