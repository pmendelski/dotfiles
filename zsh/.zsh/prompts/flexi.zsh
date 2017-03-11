#!/bin/zsh

__flexiRebuildPromptsExt() {
    buildPS4() {
        if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
            echo "+ "
            return;
        fi
        local gray blue reset cyan magenta
        if [ $__FLEXI_PROMPT_COLORS != 0 ]; then
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
        if [ $__FLEXI_PROMPT_SIMPLE -eq 1 ]; then
            echo "> "
            return;
        fi
        local reset cyan
        if [ $__FLEXI_PROMPT_COLORS != 0 ]; then
            local reset=$COLOR_RESET
            local cyan=$COLOR_CYAN_BOLD
        fi
        echo "$cyan(%_)>$reset ";
    }

    export PS2="$(buildPS2)"
    export PS4="$(buildPS4)"
}

__flexiPromptSetupDefaultsExt() {
    # Prompt constants
    : ${__FLEXI_PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD%n@%m$COLOR_RESET:$COLOR_BLUE_BOLD%~$COLOR_RESET\$ "}
    : ${__FLEXI_PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}%n@%m:%~\$ "}
    : ${__FLEXI_PROMPT_UNPRINTABLE_PREFIX:="%{"}
    : ${__FLEXI_PROMPT_UNPRINTABLE_SUFFIX:="%}"}
    : ${__FLEXI_PROMPT_TITLE_PREFIX:="\e]0;"}
    : ${__FLEXI_PROMPT_TITLE_SUFFIX:="\007"}
    : ${__FLEXI_PROMPT_GIT_UNTRACKED_FILES:="%%"}
    : ${__FLEXI_PROMPT_PS2:=0}
    : ${__FLEXI_PROMPT_PS4:=0}
}

# Load flexi prompt
bashChangePrompt 'flexi'
# Initial prompt build
flexiPromptTheme

# Register hooks
autoload -U add-zsh-hook
add-zsh-hook preexec __flexiPromptPreExec
add-zsh-hook precmd __flexiPromptPreCmd
