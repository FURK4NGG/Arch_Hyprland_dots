#!/bin/bash

case "$1" in
  wifi)
    WIFI_STATUS=$(nmcli radio wifi)

    if [ "$WIFI_STATUS" = "enabled" ]; then
      nmcli radio wifi off
      pkill nm-applet
    else
      nmcli radio wifi on
      sleep 0.3
      nm-applet &
    fi
    ;;

  bluetooth|bt)
    BT_STATUS=$(bluetoothctl show | awk '/Powered:/ {print $2}')

    if [ "$BT_STATUS" = "yes" ]; then
      bluetoothctl power off
    else
      bluetoothctl power on
    fi
    ;;
esac
