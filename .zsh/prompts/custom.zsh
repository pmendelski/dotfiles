#!/bin/zsh

rebuildPrompts2() {

    buildPS4() {
        if [ $__PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $__PROMPT_COLORS != 0 ]; then
            local gray=$COLOR_GRAY_INT_BOLD
            local blue=$COLOR_BLUE_BOLD
            local reset=$COLOR_RESET
            local cyan=$COLOR_CYAN_BOLD
            local magenta=$COLOR_MAGENTA
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
        if [ $__PROMPT_SIMPLE -eq 1 ]; then
            echo "> "
            return;
        fi
        local reset cyan
        if [ $__PROMPT_COLORS != 0 ]; then
            local reset=$COLOR_RESET
            local cyan=$COLOR_CYAN_BOLD
        fi
        echo "$cyan(%_)>$reset ";
    }

    export PS2="$(buildPS2)"
    export PS4="$(buildPS4)"
}

# Prompt constants
__PROMPT_BASIC="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD%n@%m$COLOR_RESET:$COLOR_BLUE_BOLD%~$COLOR_RESET\$ "
__PROMPT_BASIC_NO_COLORS="${debian_chroot:+($debian_chroot)}%n@%m:%~\$ "
__PROMPT_UNPRINTABLE_PREFIX="%{"
__PROMPT_UNPRINTABLE_SUFFIX="%}"
__PROMPT_TITLE_PREFIX="%{\e]0;"
__PROMPT_TITLE_SUFFIX="\007%}"
__PROMPT_GIT_UNTRACKED_FILES="%%"
__PROMPT_PS2=0
__PROMPT_PS4=0

# Initial prompt build
source $BASH_DIR/prompts/custom.sh "pure"
rebuildPrompts

# Timer mechanism
autoload -U add-zsh-hook
add-zsh-hook preexec __promptPreExec
add-zsh-hook precmd __promptPreCmd
