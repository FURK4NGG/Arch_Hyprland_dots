#!/bin/bash

STATE="$HOME/.config/scripts/brightness_mode_state"
CACHE="$HOME/.config/scripts/ddc-map.conf"
ARG="$1"

MODES=(10 35 55 80 100)

# State dizini
mkdir -p "$(dirname "$STATE")"

# Mevcut mod
MODE=$(cat "$STATE" 2>/dev/null || echo 1)
((MODE < 1 || MODE > 5)) && MODE=1

BRIGHTNESS="${MODES[$((MODE-1))]}"

# Aktif monitör
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')

if [ -z "$ACTIVE_MONITOR" ]; then
  notify-send "Brightness" "Active monitor not found"
  exit 1
fi

# I2C bul
I2C=$(grep "^$ACTIVE_MONITOR=" "$CACHE" | cut -d= -f2)

if [ -z "$I2C" ]; then
  notify-send "Brightness" "I2C bus not found: $ACTIVE_MONITOR"
  exit 1
fi

if [ -n "$ARG" ]; then
    case "$ARG" in
      *[0-9]* )
        if [[ "$ARG" =~ ^[1-5]$ ]]; then
          BRIGHTNESS="${MODES[$(($ARG-1))]}"
          MODE=$ARG
        else
          echo "Kullanim/Usage:"
          echo "  $0            -> Toggle Screen Brightness Mode   (%10/%35/%55/%80/%100)"
          echo "  $0 1,2,3,4,5  -> Screen Brightness Mode *Manuel* (%10/%35/%55/%80/%100)"
          exit 0
        fi
        ;;
      -h|help|-help|--help|*)
        echo "Kullanim/Usage:"
        echo "  $0            -> Toggle Screen Brightness Mode   (%10/%35/%55/%80/%100)"
        echo "  $0 1,2,3,4,5  -> Screen Brightness Mode *Manuel* (%10/%35/%55/%80/%100)"
        exit 0
        ;;
    esac

fi

# Parlaklık ayarla
ddcutil setvcp 10 "$BRIGHTNESS" --bus="$I2C"

echo "Mode $MODE / 5 → $BRIGHTNESS% ($ACTIVE_MONITOR)"

notify-send "Brightness Mode" \
  "Mode $MODE / 5 → $BRIGHTNESS% ($ACTIVE_MONITOR)"


# Sonraki moda geç
NEXT=$((MODE + 1))
((NEXT > 5)) && NEXT=1
echo "$NEXT" > "$STATE"
