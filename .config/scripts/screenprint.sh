#!/bin/bash

DIR="$HOME/Resimler"
FILE="tam-ekran-$(date +%Y%m%d-%H%M%S).png"
ARG="$1"


if [ -z "$ARG" ]; then
    grim "$DIR/$FILE" \
    && notify-send "Screenshot taken" "All Screens"
    exit 0
fi

case "$ARG" in
    only-one)
        OUTPUT=$(slurp -o -f "%o") || exit 0
        grim -o "$OUTPUT" "$DIR/$FILE" \
        && notify-send "Screenshot taken" "Selected Screen"
        ;;
    -h|help|-help|--help|*)
        echo "Kullanim/Usage:"
        echo "  $0           ->  Take screenshot for all screens in one save"
        echo "  $0 only-one  ->  Take screenshot for selected screen"
        exit 0
        ;;
esac
