#!/bin/bash

STATE_FILE="$HOME/.cache/screenrec.state"
DIR="$HOME/Resimler"
FILE="$DIR/screen_capture_$(date +%Y%m%d-%H%M%S).mp4"

# Help
if [ $# -gt 0 ]; then
    echo "Usage:"
    echo "  $0   ->  Toggle screen recording"
    exit 0
fi

if [ -f "$STATE_FILE" ]; then
    rm -f "$STATE_FILE"
    pkill wf-recorder
    notify-send "Recording stopped"
else
    # Tek ekran seçimi (interaktif ama güvenli)
    GEOM=$(slurp -o -f "%x,%y %wx%h" 2>/dev/null) || exit 0

    touch "$STATE_FILE"
    notify-send "Recording started"

    wf-recorder \
        -g "$GEOM" \
        -f "$FILE" \
        -a alsa_output.pci-0000_0d_00.6.analog-stereo.monitor &
fi
