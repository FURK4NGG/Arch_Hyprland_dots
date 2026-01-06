#!/bin/bash

case "$1" in
  wifi)
    WIFI_STATUS=$(nmcli radio wifi)

    if [ "$WIFI_STATUS" = "enabled" ]; then
      # Wi-Fi KAPAT
      nmcli radio wifi off
      pkill nm-applet
    else
      # Wi-Fi AÇ
      nmcli radio wifi on
      sleep 0.3
      nm-applet &
    fi
    ;;

  bluetooth|bt)
    BT_STATUS=$(bluetoothctl show | grep "Powered:" | awk '{pr>

    if [ "$BT_STATUS" = "yes" ]; then
      # Bluetooth KAPAT
      bluetoothctl power off
      pkill blueman-applet
    else
      # Bluetooth AÇ
      bluetoothctl power on
      blueman-manager &
    fi
    ;;
esac
