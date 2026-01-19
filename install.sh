#!/bin/bash

# Renkli yazılar için
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m" # reset

# Kurulacak paket listesi
PACKAGES="linux linux-zen hyprlock xorg-server mesa vulkan-radeon libva libva-utils wayland wayland-protocols mesa vulkan-radeon base-devel wlogout sddm trash-cli hyprpaper hyprland xdg-desktop-portal xdg-desktop-portal-hyprland libinput libxkbcommon qt5-graphicaleffects ddcutil i2c-tools jq gtk3 gdk-pixbuf2 gtk-layer-shell waybar ttf-twemoji swaync wl-clipboard kitty btop rofi grim slurp wf-recorder mpv atril ristretto hyprpicker thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git mousepad tumbler pipewire pipewire-pulse wireplumber alsa-utils pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin"
PACKAGES-Y="bluez bluez-utils blueman hyprshade"
echo -e "${GREEN}Do you want to install documents? (y/n)${NC}"
read -r answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo -e "${GREEN}Installing packages: $PACKAGES ...${NC}"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
	echo -e "${GREEN}Do you want a quick setup?(downloads all packages) (y/n)${NC}"
	read -r answer

	if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    	sudo pacman -Syu --noconfirm $PACKAGES
    	yay -S --noconfirm $PACKAGES_YAY
	else
    	echo -e "${GREEN}Selective install mode${NC}"

    	for pkg in $PACKAGES; do
        	read -rp "Install $pkg? (y/n): " ans
        	if [[ "$ans" =~ ^[Yy]$ ]]; then
            	sudo pacman -S --needed "$pkg"
        	fi
    	done

    	for pkg in $PACKAGES_YAY; do
        	read -rp "Install $pkg (AUR)? (y/n): " ans
        	if [[ "$ans" =~ ^[Yy]$ ]]; then
            	yay -S --needed "$pkg"
        	fi
    	done
	fi

    if [[ $? -eq 0 ]]; then
	sudo systemctl enable sddm
	sudo systemctl start sddm

	systemctl --user enable --now pipewire
	systemctl --user enable --now pipewire-pulse
	systemctl --user enable --now wireplumber

	sudo rfkill unblock bluetooth

	xdg-mime default mpv.desktop video/mp4 
	xdg-mime default mpv.desktop video/x-matroska
	xdg-mime default mpv.desktop video/webm

	sudo systemctl enable --now NetworkManager
	sudo systemctl enable --now bluetooth
	sudo usermod -aG bluetooth "$USER"

	sudo modprobe i2c-dev
	echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
    sudo usermod -aG i2c "$USER"

	sudo systemctl enable --now udisks2

	echo -e "${GREEN}Download and installation completed successfully!${NC}"

    else
        echo -e "${RED}Installation failed. Please check errors.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Skipping installation.${NC}"
fi

echo -e "${GREEN}Do you want to install configs? (y/n)${NC}"
read -r answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
	# SDDM servisini enable + start (kurulum başarılı olduktan sonra)
        echo -e "${GREEN}Enabling services...${NC}"

	cd /Arch_Hyprland_dots/

	echo -e "${GREEN}Do you want to overwrite if you have the docs? (y/n)${NC}"
	read -r answer

	if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
		sudo cp -rf .config/ /home/$USER/
		sudo cp -rf themes_bg/modest-dark/ /usr/share/icons/

	else
		sudo cp -ri .config/ /home/$USER/
		sudo cp -ri themes_bg/modest-dark/ /usr/share/icons/
	fi
 	hyprctl reload

 	sudo mkdir /etc/xdg/swaync/  
	mkdir -p ~/.local/bin
	sudo cp ~/.config/swaync/style.css /etc/xdg/swaync/style.css
	sudo cp ~/.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
	sudo chmod +x ~/.config/scripts/*.sh
	sudo chmod +x ~/.local/bin/hyprshade-auto.sh

	sudo mkdir /home/$USER/Resimler/wallpapers/
	sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	sudo mkdir /boot/loader/
	sudo cp boot/loader/loader.conf /boot/loader/loader.conf

	sudo chmod +x ~/.config/waybar/scripts/weather.py  

 	sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
	sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state
	systemctl --user daemon-reload
	systemctl --user enable --now hyprshade-auto.timer

	sudo chmod 600 ~/.config/scripts/brightness_mode_state
	sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state

	echo -e "${GREEN}Enabling services finished succesfully${NC}"
else
	echo -e "${RED}Skipping configs setup.${NC}"
fi

echo -e "${GREEN}Do you want to reboot now? (y/n)${NC}"
read -r reboot_ans

if [[ "$reboot_ans" == "y" || "$reboot_ans" == "Y" ]]; then
    echo -e "${GREEN}Rebooting...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Installation completed successfully!${NC}"
fi
