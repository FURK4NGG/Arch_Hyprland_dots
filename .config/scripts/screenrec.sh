#!/bin/bash

STATE_FILE="$HOME/.cache/toggle-example.state"

if [ -f "$STATE_FILE" ]; then
    # İkinci basış (state varsa)
    rm "$STATE_FILE"
    pkill wf-recorder && notify-send "Ekran kaydı alındı"
    # İkinci basışta çalışacak komut
    # echo "İkinci komut çalıştı"
else
    # İlk basış (state yoksa)
    touch "$STATE_FILE"
    notify-send "Ekran kaydı basladı" && wf-recorder -f ~/Resimler/screen_capture_$(date +%Y%m%d-%H%M%S).mp4 -a alsa_output.pci-0000_0d_00.6.analog-stereo.monitor
    # İlk basışta çalışacak komut
    # echo "İlk komut çalıştı"
fi
