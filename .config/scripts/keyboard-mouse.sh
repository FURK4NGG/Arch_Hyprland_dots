#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/keyboard-mouse"
ACTIVE_FILE="$STATE_DIR/active"

mkdir -p "$STATE_DIR"

case "${1:-}" in
    start)
        touch "$ACTIVE_FILE"

        notify-send \
            -a "Keyboard Mouse" \
            -r 9876 \
            -t 1500 \
            "Keyboard Mouse" \
            "Mouse mode enabled"
        ;;

    stop)
        rm -f "$ACTIVE_FILE"

        notify-send \
            -a "Keyboard Mouse" \
            -r 9876 \
            -t 1500 \
            "Keyboard Mouse" \
            "Mouse mode disabled"
        ;;

    left-click)
        ydotool click 0xC0
        ;;

    middle-click)
        ydotool click 0xC2
        ;;

    right-click)
        ydotool click 0xC1
        ;;

    *)
        echo "Usage: $0 start|stop|left-click|middle-click|right-click" >&2
        exit 1
        ;;
esac
