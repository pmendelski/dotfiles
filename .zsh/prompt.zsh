#!/bin/bash

# Prompt constants
__PROMPT_UNPRINTABLE_PREFIX="%{"
__PROMPT_UNPRINTABLE_SUFFIX="%}"
__PROMPT_TITLE_PREFIX="%{\e]0;"
__PROMPT_TITLE_SUFFIX="\007%}"

# Defaults - move some data to rprompt
: ${PROMPT_GIT:=0}
: ${PROMPT_TIMER:=0}

source $BASH_DIR/prompt.sh

# Initial prompt build
rebuildPrompts

# Timer mechanism
autoload -U add-zsh-hook
add-zsh-hook preexec promptPreExec
add-zsh-hook precmd promptPreCmd

rebuildRightPrompt() {

    buildRprompt() {
        [ $PROMPT_SIMPLE -eq 1 ] || [ $RPROMPT_ENABLED = 0 ] && return
        local rprompt=""
        [ $RPROMPT_TIMER != 0 ] && rprompt+="$__PROMPT_TIMER_COLOR\$(__promptTimer $RPROMPT_TIMER)"
        [ $RPROMPT_STATUS != 0 ] && rprompt+="\$(declare cmdstatus=\$?; [ \$cmdstatus != 0 ] && echo \"${__PROMPT_CMD_ERR_COLOR}err:\$cmdstatus \"; exit \$cmdstatus)"
        [ $RPROMPT_GIT != 0 ] && rprompt+="$__PROMPT_REPO_COLOR\$(__promptGitStatus)"
        [ $RPROMPT_TIMESTAMP != 0 ] && rprompt+="$__PROMPT_TIMESTAMP_COLOR\$(__promptTimestamp)"
        rprompt+="$__PROMPT_COLOR_RESET"
        echo "$rprompt";
    }

    export RPROMPT="$(buildRprompt)"    # Prompt string
}

function __rprompt_define_opt() {
    local funcname=$1
    local varname=$2
    local default=$3
    # Setup default value
    eval $varname=\${$varname-$default}
    # Setup toggle function
    eval "$(echo "
    function $funcname() {
        local a=\$(echo "\$1" | tr '[:lower:]' '[:upper:]')
        if [ -z \$a ]; then
            [ \$$varname = 0 ] && $varname=1 || $varname=0;
        elif [ "\$a" == "TRUE" ] || [ "\$a" == "T" ] || [ "\$a" == "1" ]; then
            $varname=1
        elif [ "\$a" == "FALSE" ] || [ "\$a" == "F" ] || [ "\$a" == "0" ]; then
            $varname=0
        else
            $varname=\$1
        fi
        rebuildRightPrompt
    }")"
}

# Right Prompt Config
## Show right prompt
__rprompt_define_opt rprompt_enabled RPROMPT_ENABLED 1
## Show GIT status
__rprompt_define_opt rprompt_git RPROMPT_GIT $(hash git 2>/dev/null && echo 1)
## Show last command result status
__rprompt_define_opt rprompt_status RPROMPT_STATUS 1
## Add timestamp to prompt (date format)
__rprompt_define_opt rprompt_timestamp RPROMPT_TIMESTAMP 0
## Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__rprompt_define_opt rprompt_timer RPROMPT_TIMER -1


rebuildRightPrompt
