#!/bin/bash

STATE="$HOME/.config/scripts/brightness_mode"
CACHE="$HOME/.config/scripts/ddc-map.conf"

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

# Parlaklık ayarla
ddcutil setvcp 10 "$BRIGHTNESS" --bus="$I2C"

notify-send "Brightness Mode" \
  "Mode $MODE / 5 → $BRIGHTNESS% ($ACTIVE_MONITOR)"

# Sonraki moda geç
NEXT=$((MODE + 1))
((NEXT > 5)) && NEXT=1
echo "$NEXT" > "$STATE"
