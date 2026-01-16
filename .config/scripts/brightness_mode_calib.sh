#!/bin/bash

CACHE="$HOME/.config/scripts/ddc-map.conf"

# Dizini garanti altına al
mkdir -p "$(dirname "$CACHE")" || exit 1
chmod 700 "$(dirname "$CACHE")"

# Eski dosyayı temizle
: > "$CACHE"
chmod 600 "$CACHE"

echo "Check the output of ddcutil detect and enter the I2C bus number."

# monitörleri JSON ile al
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
OUTPUT=$(ddcutil detect)

echo "$OUTPUT"

for MON in $MONITORS; do
  echo
  echo "Monitor: $MON"                  

  while true; do
    read -rp "I2C bus number *last number* (only number): " BUS

    # Trim boşlukları
    BUS=$(echo "$BUS" | tr -d '[:space:]')

    # Sadece sayı mı?
    if [[ "$BUS" =~ ^[0-9]+$ ]]; then
      echo "$MON=$BUS" >> "$CACHE"
      break
    else
      echo "❌ Invalid input. Please enter a number (e.g., 4)"
    fi
  done
done

echo
echo "✔ Saved: $CACHE"
