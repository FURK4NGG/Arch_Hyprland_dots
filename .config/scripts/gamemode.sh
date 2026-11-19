#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/toggle-gamemode-state"

hk() { hyprctl keyword "$@" > /dev/null 2>&1; }

if [ -f "$STATE_FILE" ]; then
    # ---------- DISABLE ----------
    # shellcheck disable=SC1090
    . "$STATE_FILE"
    rm -f "$STATE_FILE"

    # Restore Hyprland settings from the config file
    hyprctl dispatch submap reset > /dev/null
    hyprctl reload > /dev/null

    # Power profile
    command -v powerprofilesctl > /dev/null && \
        powerprofilesctl set "${PREV_PROFILE:-balanced}" 2> /dev/null

    # swaync: turn DND off only if it was off before
    if [ "$PREV_DND" != "true" ]; then
        swaync-client --dnd-off > /dev/null 2>&1
    fi

    # hypridle: restart it if it was running before
    if [ "$PREV_HYPRIDLE" = "1" ]; then
        setsid -f hypridle > /dev/null 2>&1
    fi

    notify-send -a "Game Mode" "Game Mode" "Closed"
else
    # ---------- ENABLE ----------
    # Save previous state
    {
        echo "PREV_PROFILE=$(powerprofilesctl get 2> /dev/null || echo balanced)"
        echo "PREV_DND=$(swaync-client --get-dnd 2> /dev/null || echo false)"
        if pgrep -x hypridle > /dev/null; then
            echo "PREV_HYPRIDLE=1"
        else
            echo "PREV_HYPRIDLE=0"
        fi
    } > "$STATE_FILE"

    # Show the notification before DND is enabled
    notify-send -a "Game Mode" "Game Mode" "Active (Close with ALT + G)"
    sleep 0.5

    # Gaps, rounding, border
    hk general:gaps_in 0
    hk general:gaps_out 0
    hk general:border_size 0
    hk decoration:rounding 0

    # Visual effects
    hk decoration:blur:enabled false
    hk animations:enabled false
    hk decoration:shadow:enabled false   # newer versions
    hk decoration:drop_shadow false      # older versions

    # Tearing, VRR, direct scanout
    hk general:allow_tearing true
    hk misc:vrr 2
    hk render:direct_scanout 1

    # Flat mouse acceleration
    hk input:accel_profile flat
    hk input:force_no_accel 1

    # CPU/power profile
    command -v powerprofilesctl > /dev/null && \
        powerprofilesctl set performance 2> /dev/null

    # Silence notifications
    swaync-client --dnd-on > /dev/null 2>&1

    # Stop screen lock/idle handling (hypridle)
    pkill -x hypridle

    hyprctl dispatch submap gamemode > /dev/null
fi
