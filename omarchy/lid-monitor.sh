#!/bin/bash
# Hyprland Lid Handler for Lenovo Legion Y740
# Reacts to lid open/close events and enables/disables the internal display

INTERNAL="eDP-1"       # your laptop display
EXTERNAL="DP-1"        # your external display

# Infinite loop monitoring lid events via systemd-logind D-Bus
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.login1.Manager'" | \
while read -r line; do
    # Only process lines containing LidClosed
    if echo "$line" | grep -q "LidClosed"; then
        # Extract true/false from the line
        LID=$(echo "$line" | grep -oP "LidClosed\s*=\s*\K(true|false)")

        if [ "$LID" = "true" ]; then
            echo "$(date) - Lid closed: disabling $INTERNAL"
            hyprctl keyword monitor "$INTERNAL, disable"
        else
            echo "$(date) - Lid opened: enabling $INTERNAL"
            hyprctl keyword monitor "$INTERNAL, preferred, auto, 1"
        fi
    fi
done
