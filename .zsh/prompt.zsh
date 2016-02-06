#!/bin/bash

# Prompt constants
__PROMPT_UNPRINTABLE_PREFIX="%{"
__PROMPT_UNPRINTABLE_SUFFIX="%}"
__PROMPT_TITLE_PREFIX="%{\e]0;"
__PROMPT_TITLE_SUFFIX="\007%}"
__PROMPT_GIT_UNTRACKED_FILES="%%"
__PROMPT_PS2=0
__PROMPT_PS4=0

# Defaults - disable some info in left to enable it in rprompt
: ${PROMPT_GIT:=0}
: ${PROMPT_TIMER:=0}
: ${PROMPT_SHLVL:=0}

source $BASH_DIR/prompt.sh

rebuildPrompts2() {

    buildRprompt() {
        [ $PROMPT_SIMPLE -eq 1 ] || [ $RPROMPT_ENABLED = 0 ] && return
        local rprompt=""
        [ $RPROMPT_TIMER != 0 ] && rprompt+="$__PROMPT_TIMER_COLOR\$(__promptTimer $RPROMPT_TIMER)"
        [ $RPROMPT_STATUS != 0 ] && rprompt+="\$(declare cmdstatus=\$?; [ \$cmdstatus != 0 ] && echo \"${__PROMPT_CMD_ERR_COLOR}[err:\$cmdstatus]\"; exit \$cmdstatus)"
        [ $RPROMPT_GIT != 0 ] && rprompt+="$__PROMPT_REPO_COLOR\$(__promptGitStatus)"
        [ $RPROMPT_TIMESTAMP != 0 ] && rprompt+="$__PROMPT_TIMESTAMP_COLOR\$(__promptTimestamp)"
        [ $RPROMPT_SHLVL != 0 ] && rprompt+="$__PROMPT_SHLVL_COLOR\$(__promptShlvl $RPROMPT_SHLVL \"/\" \"\")"
        rprompt+="$__PROMPT_COLOR_RESET"
        echo "$rprompt";
    }

    buildPS4() {
        if [ $PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $PROMPT_COLORS != 0 ]; then
            local gray=$PR_GRAY_INT_BOLD
            local blue=$PR_BLUE_BOLD
            local reset=$PR_RESET
            local cyan=$PR_CYAN_BOLD
            local magenta=$PR_MAGENTA
        fi
        local tab="\011"
        local PS4="+ ";
        PS4+="$gray%D{%H:%M:%S} "
        PS4+="$blue%x$reset:$cyan%I"
        PS4+="$reset$tab$magenta%N$gray()$reset:$tab"
        PS4+="$reset"
        echo "$PS4";
    }

    buildPS2() {
        if [ $PROMPT_SIMPLE -eq 1 ]; then
            echo "> "
            return;
        fi
        local reset cyan
        if [ $PROMPT_COLORS != 0 ]; then
            local reset=$PR_RESET
            local cyan=$PR_CYAN_BOLD
        fi
        echo "$cyan(%_)>$reset ";
    }

    export RPROMPT="$(buildRprompt)"
    export PS2="$(buildPS2)"
    export PS4="$(buildPS4)"
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
        rebuildPrompts2
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
## Show subshell count from SHLVL (-1=all, 0=never, x>0=mesure those above x ms)
__rprompt_define_opt rprompt_shlvl RPROMPT_SHLVL 1


# Initial prompt build
rebuildPrompts

# Timer mechanism
autoload -U add-zsh-hook
add-zsh-hook preexec promptPreExec
add-zsh-hook precmd promptPreCmd
