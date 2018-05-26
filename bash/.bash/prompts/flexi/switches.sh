#!/bin/bash -x

function __flexiPromptDefineSwitch() {
  local funcname="flexiPromptSwitch$1"
  local varname="__FLEXI_PROMPT_$2"
  local default=$3
  # Setup default value
  eval $varname=\${$varname-$default}
  # Setup switch function
  eval "$(echo "
  function $funcname() {
    local a=\$(echo "\$1" | tr '[:lower:]' '[:upper:]')
    if [ -z \$a ]; then
      [ \$$varname = 0 ] && $varname=1 || $varname=0;
    elif [ "\$a" = "TRUE" ] || [ "\$a" = "T" ] || [ "\$a" = "1" ]; then
      $varname=1
    elif [ "\$a" = "FALSE" ] || [ "\$a" = "F" ] || [ "\$a" = "0" ]; then
      $varname=0
    else
      $varname=\$1
    fi
    echo \"$varname=\$$varname\"
    __flexiRebuildPrompts
  }")"
}

# Use colors
__flexiPromptDefineSwitch Colors COLORS 1
# Fallback to simple prompt
__flexiPromptDefineSwitch ToSimple SIMPLE 0
# Break command line after prompt
#   0 - no line break, 1 - line break, 2 - line break skip home
__flexiPromptDefineSwitch NewLine NEWLINE 0
# Break command line before prompt
#   0 - no line break, 1 - line break
__flexiPromptDefineSwitch NewLinePrecmd NEWLINE_PRECMD 0
# Setup pwd mode (0-"~/Desktop/Project", 1-"~/a/b/c/project", 2-".../x/y/z/project")
__flexiPromptDefineSwitch PwdMode PWD_MODE 2
# Show subshell count from SHLVL (-1=all, 0=never, x>0=mesure those above x sublevels)
__flexiPromptDefineSwitch Shlvl SHLVL 1
# Show GIT status
__flexiPromptDefineSwitch Git GIT $(hash git 2>/dev/null && echo 1)
# Long running cmd notification (-1=all, 0=never, x>0=mesure those above x ms)
__flexiPromptDefineSwitch Notify NOTIFY 5000
# Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__flexiPromptDefineSwitch Timer TIMER 5000
# Add timestamp to prompt (date format)
__flexiPromptDefineSwitch Timestamp TIMESTAMP 0
# Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
__flexiPromptDefineSwitch DefaultUserHost PROMPT_DEFAULT_USERHOST ""

unset -f __flexiPromptDefineSwitch
