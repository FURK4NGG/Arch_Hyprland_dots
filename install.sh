#!/bin/bash

# Renkli yazılar için
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m" # reset

# Kurulacak paket listesi
PACKAGES="linux linux-zen hyprlock wlogout sddm hyprpaper hyprland wlroots xdg-desktop-portal-hyprland qt5-graphicaleffects waybar ttf-twemoji swaync wl-clipboard kitty btop rofi gammastep grim slurp wf-recorder mpv atril ristretto thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git mousepad vscodium tumbler pipewire pipewire-pulse wireplumber alsa-utils pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin xfce4-network-manager"

echo -e "${GREEN}Do you want to install documents? (y/n)${NC}"
read -r answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo -e "${GREEN}Installing packages: $PACKAGES ...${NC}"
    sudo pacman -Syu --noconfirm $PACKAGES

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Download and installation completed successfully!${NC}"

        # SDDM servisini enable + start (kurulum başarılı olduktan sonra)
        echo -e "${GREEN}Enabling services...${NC}"
        cd Arch_Hyprland_dots

	sudo cp -r .config/ /home/$USER/

	sudo cp -r themes_bg/modest-dark/ /usr/share/icons/

	sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	sudo cp boot/loader/loader.conf /boot/loader/loader.conf

	sudo systemctl enable sddm
	sudo systemctl start sddm

	systemctl --user enable --now pipewire
	systemctl --user enable --now pipewire-pulse
	systemctl --user enable --now wireplumber

	xdg-mime default mpv.desktop video/mp4 xdg-mime default mpv.desktop video/x-matroska
	xdg-mime default mpv.desktop video/webm

	sudo systemctl enable --now NetworkManager

	sudo systemctl enable --now udisks2

	systemctl --user daemon-reload
	systemctl --user enable --now gammastep-refresh.timer

	echo -e "${GREEN}Enabling services finished succesfully${NC}"
    else
        echo -e "${RED}Installation failed. Please check errors.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Skipping installation.${NC}"
fi

echo -e "${GREEN}Do you want to reboot now? (y/n)${NC}"
read -r reboot_ans

if [[ "$reboot_ans" == "y" || "$reboot_ans" == "Y" ]]; then
    echo -e "${GREEN}Rebooting...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Installation completed successfully!${NC}"
fi
