#!/bin/bash

DIR="$HOME/Resimler"
mkdir -p "$DIR"

ARG="$1"

if [ -z "$ARG" ]; then
    FILE="tam-ekran-$(date +%Y%m%d-%H%M%S).png"
    grim "$DIR/$FILE" \
    && notify-send "Screenshot taken" "All Screens" \
    && printf '%s\n' "$DIR/$FILE"
    exit 0
fi

case "$ARG" in
    only-one)
        GEOM="$(slurp 2>/dev/null || true)"
        [ -z "$GEOM" ] && exit 0

        POS_PART="${GEOM%% *}"
        SIZE_PART="${GEOM#* }"

        X="${POS_PART%,*}"
        Y="${POS_PART#*,}"
        W="${SIZE_PART%x*}"
        H="${SIZE_PART#*x}"

        case "$X" in ''|*[!0-9]*) exit 0 ;; esac
        case "$Y" in ''|*[!0-9]*) exit 0 ;; esac
        case "$W" in ''|*[!0-9]*) exit 0 ;; esac
        case "$H" in ''|*[!0-9]*) exit 0 ;; esac

        # Tek tıklama -> seçilen ekranın tamamı
        if [ "$W" -le 5 ] || [ "$H" -le 5 ]; then
            FILE="tam-ekran-$(date +%Y%m%d-%H%M%S).png"

            OUTPUT_NAME="$(
                hyprctl monitors -j 2>/dev/null | python3 -c '
import sys, json

x = int(sys.argv[1])
y = int(sys.argv[2])

try:
    mons = json.load(sys.stdin)
except Exception:
    sys.exit(1)

for m in mons:
    mx = int(m.get("x", 0))
    my = int(m.get("y", 0))
    mw = int(m.get("width", 0))
    mh = int(m.get("height", 0))

    if mx <= x < mx + mw and my <= y < my + mh:
        print(m.get("name", ""))
        sys.exit(0)

sys.exit(1)
' "$X" "$Y"
            )"

            [ -z "$OUTPUT_NAME" ] && exit 0

            grim -o "$OUTPUT_NAME" "$DIR/$FILE" \
            && notify-send "Screenshot taken" "Selected Screen" \
            && printf '%s\n' "$DIR/$FILE"
        else
            FILE="secili-alan-$(date +%Y%m%d-%H%M%S).png"

            grim -g "$GEOM" "$DIR/$FILE" \
            && notify-send "Screenshot taken" "Selected Area" \
            && printf '%s\n' "$DIR/$FILE"
        fi
        ;;
    -h|help|-help|--help)
        echo "Kullanim/Usage:"
        echo "  $0           ->  Take screenshot for all screens in one save"
        echo "  $0 only-one  ->  Click = selected screen, drag = selected area"
        exit 0
        ;;
    *)
        echo "Kullanim/Usage:"
        echo "  $0           ->  Take screenshot for all screens in one save"
        echo "  $0 only-one  ->  Click = selected screen, drag = selected area"
        exit 0
        ;;
esac
