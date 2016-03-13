#!/bin/bash

function chromium-profile-add-desktop() {
    declare -r profile="$1"
    declare -r profile_desktop="$HOME/.local/share/applications/chromium-browser-$profile.desktop"
    declare -r profile_dir="$HOME/.config/chromium/profiles/$profile"
    mkdir -p "$HOME/.config/chromium/profiles"
    echo "
[Desktop Entry]
Version=1.0
Name=Chromium Web Browser - $profile
GenericName=Web Browser - $profile
Comment=Access the Internet
Exec=chromium-browser --user-data-dir=\"$HOME/.config/chromium/profiles/$profile\" %U
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=chromium-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Actions=NewWindow;Incognito;TempProfile;
X-AppInstall-Package=chromium-browser

[Desktop Action NewWindow]
Name=Open a New Window
Exec=chromium-browser --user-data-dir=\"$HOME/.config/chromium/profiles/$profile\" %U

[Desktop Action Incognito]
Name=Open a New Window in incognito mode
Exec=chromium-browser --incognito

[Desktop Action TempProfile]
Name=Open a New Window with a temporary profile
Exec=chromium-browser --temp-profile
"   > "$profile_desktop"
}

function chromium-profile-rm() {
    declare -r profile="$1"
    declare -r profile_desktop="$HOME/.local/share/applications/chromium-browser-$profile.desktop"
    declare -r profile_dir="$HOME/.config/chromium/profiles/$profile"
    rm -r "$profile_dir" >/dev/null 2>&1 && \
        echo "Removed profile dir: $profile_dir" || \
        echo "No profile dir: $profile_dir"
    rm "$profile_desktop" >/dev/null 2>&1 && \
        echo "Removed profile desktop: $profile_desktop" || \
        echo "No profile desktop: $profile_dir"
}

function chromium-profile-open() {
    declare -r profile="$1"
    mkdir -p "$HOME/.config/chromium/profiles"
    chromium-browser --user-data-dir="$HOME/.config/chromium/profiles/$profile" >/dev/null 2>&1 &
    disown
}
