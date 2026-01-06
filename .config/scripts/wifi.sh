#!/bin/bash

STATUS=$(nmcli radio wifi)

if [ "$STATUS" = "enabled" ]; then
  # Wi-Fi KAPAT
  nmcli radio wifi off
  pkill nm-applet
else
  # Wi-Fi AÇ
  nmcli radio wifi on
  nm-applet &
fi
