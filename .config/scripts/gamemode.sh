#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/toggle-gamemode-state"

hk() { hyprctl keyword "$@" > /dev/null 2>&1; }

if [ -f "$STATE_FILE" ]; then
    # ---------- KAPAT ----------
    # shellcheck disable=SC1090
    . "$STATE_FILE"
    rm -f "$STATE_FILE"

    # Hyprland ayarlarını config'ten geri yükle
    hyprctl dispatch submap reset > /dev/null
    hyprctl reload > /dev/null

    # Güç profili
    command -v powerprofilesctl > /dev/null && \
        powerprofilesctl set "${PREV_PROFILE:-balanced}" 2> /dev/null

    # swaync: önceden kapalıysa DND'yi kapat
    if [ "$PREV_DND" != "true" ]; then
        swaync-client --dnd-off > /dev/null 2>&1
    fi

    # hypridle: önceden çalışıyorsa yeniden başlat
    if [ "$PREV_HYPRIDLE" = "1" ]; then
        setsid -f hypridle > /dev/null 2>&1
    fi

    notify-send -a "Game Mode" "Game Mode" "Closed"
else
    # ---------- AÇ ----------
    {
        echo "PREV_PROFILE=$(powerprofilesctl get 2> /dev/null || echo balanced)"
        echo "PREV_DND=$(swaync-client --get-dnd 2> /dev/null || echo false)"
        if pgrep -x hypridle > /dev/null; then
            echo "PREV_HYPRIDLE=1"
        else
            echo "PREV_HYPRIDLE=0"
        fi
    } > "$STATE_FILE"

    # Bildirimi DND açılmadan önce göster
    notify-send -a "Game Mode" "Game Mode" "Active (Close with ALT + G)"
    sleep 0.5

    # Gaps, rounding, border
    hk general:gaps_in 0
    hk general:gaps_out 0
    hk general:border_size 0
    hk decoration:rounding 0

    # Görsel efektler
    hk decoration:blur:enabled false
    hk animations:enabled false
    hk decoration:shadow:enabled false   # yeni sürümler
    hk decoration:drop_shadow false      # eski sürümler

    # Tearing, VRR, direct scanout
    hk general:allow_tearing true
    hk misc:vrr 2
    hk render:direct_scanout 1

    # Düz fare ivmesi
    hk input:accel_profile flat
    hk input:force_no_accel 1

    # CPU/güç profili
    command -v powerprofilesctl > /dev/null && \
        powerprofilesctl set performance 2> /dev/null

    # Bildirimleri sustur
    swaync-client --dnd-on > /dev/null 2>&1

    # Ekran kilidi/uyku (hypridle) durdur
    pkill -x hypridle

    hyprctl dispatch submap gamemode > /dev/null
fi
