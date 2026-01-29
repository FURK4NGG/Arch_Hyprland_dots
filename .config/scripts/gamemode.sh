#!/bin/bash

STATE_FILE="$HOME/.cache/toggle-gamemode-state"

if [ -f "$STATE_FILE" ]; then
    # İkinci basış (state varsa)
    rm "$STATE_FILE"
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword animations:enabled true
    hyprctl keyword general:allow_tearing false
    hyprctl keyword decoration:drop_shadow false
    notify-send "Game Mode" "game mode is deactive"
    hyprctl dispatch submap reset
else
    # İlk basış
    touch "$STATE_FILE"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword animations:enabled false
    hyprctl keyword general:allow_tearing true
    hyprctl keyword decoration:drop_shadow false
    notify-send "Game Mode" "ALT + G to stop gamemode"
    notify-send "Game Mode" "game mode is active"
    hyprctl dispatch submap gamemode
fi
