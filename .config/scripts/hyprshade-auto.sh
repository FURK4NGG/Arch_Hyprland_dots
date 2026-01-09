#!/bin/bash

STATE_FILE="$HOME/.config/scripts/hyprshade-toggle-state"
SHADER="$HOME/.config/scripts/night_screen.frag"
HOUR=$(date +%H)
ARG="$1"

if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE" || exit 1
    chmod 600 "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")


case "$STATE" in
    0)
        # DEFAULT (AUTO)
        sudo systemctl --user start hyprshade-auto.service
        sudo systemctl --user enable hyprshade-auto.service
        sudo systemctl --user start hyprshade-auto.timer
        sudo systemctl --user enable hyprshade-auto.timer
        if [ "$HOUR" -ge 19 ] || [ "$HOUR" -lt 7 ]; then
            hyprshade on "$SHADER"
        else
            hyprshade off
        fi

        if [ "$ARG" = "time" ]; then
            echo "night_mode controlled"
            echo 0 > "$STATE_FILE"
        else
            echo "Default (auto) mod"
            echo 1 > "$STATE_FILE"
            notify-send "Night Screen" "auto mode active"
        fi
        ;;
    1)
        # KAPALI
        sudo systemctl --user stop hyprshade-auto.service
        sudo systemctl --user disable hyprshade-auto.service
        sudo systemctl --user stop hyprshade-auto.timer
        sudo systemctl --user disable hyprshade-auto.timer
        hyprshade off
        echo "Kapalı mod"
        echo 2 > "$STATE_FILE"
        notify-send "Night Screen" "effect is deactive"
        ;;
    2)
        # HEP AÇIK
        sudo systemctl --user stop hyprshade-auto.service
        sudo systemctl --user disable hyprshade-auto.service
        sudo systemctl --user stop hyprshade-auto.timer
        sudo systemctl --user disable hyprshade-auto.timer
        hyprshade on "$SHADER"
        echo "Hep açık mod"
        echo 0 > "$STATE_FILE"
        notify-send "Night Screen" "effect is active"
        ;;
esac
