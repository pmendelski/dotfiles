#!/bin/zsh

# Completion cache location
ZSH_COMP_DIR="$ZSH_TMP_DIR/comp"
ZSH_COMPCACHE_DIR="$ZSH_COMP_DIR/cache"
mkdir -p "$ZSH_COMPCACHE_DIR"

# Add zsh-completions
fpath=($ZSH_TMP_DIR/bundle/completions/src $fpath)

# Initilize completion mechanism.
# http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
zmodload -i zsh/complist    # Import complist module
autoload -U compinit        # Source compinit function
compinit -i -d "$ZSH_COMP_DIR/.zcompdump-${HOST}-${ZSH_VERSION}"    # Initialize and save the location of the completion dump file.

# Completion options
# http://zsh.sourceforge.net/Doc/Release/Options.html#Completion-2
unsetopt list_beep          # No beeping
unsetopt menu_complete      # Do not autoselect the first completion entry
setopt auto_menu            # Autoselect on second tab press
setopt always_to_end        # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_name_dirs       # Any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word     # Allow completion from within a word/phrase
setopt globdots             # Enable completion for hidden files and directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$ZSH_COMPCACHE_DIR"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # Matching definition - word separators
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}   # Use LS_COLORS in autocompletion
zstyle ':completion:*:*:*:*:*' menu select


# Process autocompletion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi avahi-autoipd 
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
    clamav daemon dbus beaglidx bin cacti canna \
    clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
    gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
    ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
    operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
    usbmux uucp vcsa wwwrun xfs '_*'

# Fix git checkout autocompletion - add local name proposition for origin/feature/sth -> feature/sth
zstyle :completion::complete:git-checkout:argument-rest:headrefs command "git for-each-ref --format='%(refname)' refs/remotes 2>/dev/null | cut -d '/' -f4-"
