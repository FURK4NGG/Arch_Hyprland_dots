#!/bin/bash
notify-send "Ekran kaydı basladı" && wf-recorder -f ~/Resimler/screen_capture_$(date +%Y%m%d-%H%M%S).mp4 -a alsa_output.pci-0000_0d_00.6.analog-stereo.monitor
