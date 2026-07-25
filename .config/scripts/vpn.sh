#!/bin/bash

VPN_NAME="wg0"

if nmcli -t -f NAME connection show --active | grep -Fxq "$VPN_NAME"; then
    if nmcli connection down "$VPN_NAME"; then
        notify-send "VPN" "$VPN_NAME disconnected"
    else
        notify-send -u critical "VPN Error" "Failed to disconnect $VPN_NAME"
        exit 1
    fi
else
    if nmcli connection up "$VPN_NAME"; then
        notify-send "VPN" "$VPN_NAME connected"
    else
        notify-send -u critical "VPN Error" "Failed to connect $VPN_NAME"
        exit 1
    fi
fi
