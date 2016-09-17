#!/bin/bash
# Changes Ubuntu keybindings that clash with IntelliJ Idea (and probably other Jetbrain products).

_INTELLIJ_KEYBINDINGS=(
    # Settings dialog
    "org.gnome.desktop.wm.keybindings.toggle-shaded <Alt><Super>s"
    # Navigation
    "org.gnome.desktop.wm.keybindings.switch-to-workspace-down <Alt><Super>Down"
    "org.gnome.desktop.wm.keybindings.switch-to-workspace-up <Alt><Super>Up"
    "org.gnome.desktop.wm.keybindings.switch-to-workspace-left <Alt><Super>Left"
    "org.gnome.desktop.wm.keybindings.switch-to-workspace-right <Alt><Super>Right"
    # Find usages
    "org.gnome.desktop.wm.keybindings.begin-move <Super>F7"
    # Evaluate expression
    "org.gnome.desktop.wm.keybindings.begin-resize <Super>F8"
    # Reformat code
    "org.gnome.settings-daemon.plugins.media-keys.screensaver <Control><Super>l"
)

intellij-keybindings() {
    local binding schema key value
    for binding in "${_INTELLIJ_KEYBINDINGS[@]}" ; do
        schema=${binding% *}
        key=${schema##*.}
        schema=${binding%.*}
        value=${binding#* }
        value=${value:-disabled}
        prevalue="$(gsettings get $schema $key)"
        [ $value != "disabled" ] && [[ $schema == "org.gnome.desktop."* ]] && {
            value="['$value']"
        }
        gsettings set "$schema" "$key" "$value"
        printf "Binding: %s %s\n" "$schema" "$key"
        printf "   From: %s\n" "$prevalue"
        printf "     To: %s\n" "$(gsettings get $schema $key)"
    done
}

intellij-keybindings-reset() {
    local binding schema key value prevalue
    for binding in "${_INTELLIJ_KEYBINDINGS[@]}" ; do
        schema=${binding% *}
        key=${schema##*.}
        schema=${binding%.*}
        prevalue="$(gsettings get $schema $key)"
        gsettings reset "$schema" "$key"
        printf "Binding: %s %s\n" "$schema" "$key"
        printf "          From: %s\n" "$prevalue"
        printf "  To (default): %s\n" "$(gsettings get $schema $key)"
    done
}
