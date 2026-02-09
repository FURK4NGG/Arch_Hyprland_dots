#!/bin/bash

# Renkli yazılar için
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m" # reset

HINTS=""

# Kurulacak paket listesi
PACKAGES="linux linux-zen hyprlock xorg-server xorg-xinput xorg-xinit xorg-xrandr mesa vulkan-radeon libva libva-utils wayland wayland-protocols mesa vulkan-radeon base-devel wlogout sddm trash-cli hyprpaper hyprland xdg-desktop-portal xdg-desktop-portal-hyprland libinput libxkbcommon qt5-graphicaleffects ddcutil i2c-tools jq hypridle gtk3 gdk-pixbuf2 gtk-layer-shell waybar ttf-twemoji swaync wl-clipboard kitty btop rofi grim slurp wf-recorder mpv atril ristretto hyprpicker thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git mousepad tumbler pipewire pipewire-pulse wireplumber alsa-utils pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin"
PACKAGES_YAY="bluez bluez-utils blueman hyprshade"


M_PACKAGES=(linux linux-zen hyprlock mesa vulkan-radeon libva libva-utils wayland wayland-protocols mesa vulkan-radeon base-devel wlogout sddm trash-cli hyprpaper hyprland xdg-desktop-portal xdg-desktop-portal-hyprland libinput libxkbcommon qt5-graphicaleffects jq hypridle gtk3 gdk-pixbuf2 gtk-layer-shell waybar ttf-twemoji swaync wl-clipboard kitty btop rofi atril ristretto hyprpicker thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git mousepad tumbler pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils
'xfce-desktop("Easy setup for XFCE Desktop" sddm thunar thunar-volman thunar-archive-plugin xarchiver mesa xorg-server xorg-xinput xorg-xinit xorg-xrandr xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin libinput libxkbcommon gtk3 gdk-pixbuf2 tumbler gvfs networkmanager network-manager-applet)'
'gaming-stack(mesa vulkan-radeon libva libva-utils nvidia nvidia-settings nvidia-utils wine winetricks lutris steam gamemode mangohud)'
'script-bootloader("Set your boot time to 8 second")'
'script-keyboard-language("A program that switches between the keyboard layouts(US:TR) using the Alt + Shift keys\nRecommended for XFCE desktop environments")'
'script-brightness-control("This package allows you to control your screen brightness using five different modes\nDesigned for Sway, but can also be controlled through the terminal." ddcutil i2c-tools)'
'script-screenrec("This package for recording the screen\nDesigned for Sway, but can also be controlled through the terminal." wf-recorder)'
'script-screenprint("This package for take screenshot of the screen\nDesigned for Sway, but can also be controlled through the terminal." grim slurp)'
'script-wifi("Wifi control with sway\nDesigned for Sway, but can also be controlled through the terminal." networkmanager network-manager-applet)'
'script-gamemode("Improves performance by temporarily disabling unused system features while gaming")'
'audio-pkgs(pipewire pipewire-pulse wireplumber alsa-utils)'
'media-player-pkgs(mpv xdg-utils)'
'themes-and-icons("Themes and icons")')
M_PACKAGES_YAY=('bluetooth-pkgs(bluez bluez-utils blueman)'
'script-bt("Bluetooth control with sway\nDesigned for Sway, but can also be controlled through the terminal." bluez bluez-utils blueman)'
'script-hyprshade("Reduce blue light automatically or manually\nDesigned for Sway, but can also be controlled through the terminal." hyprshade)')

echo -e "${GREEN}Do you want to start setup? (y/n)${NC}"
read -r answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo -e "${GREEN}Installing packages: $PACKAGES ...${NC}"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..

    while true; do
    echo -e "${GREEN}Select an option:${NC}"
    echo "1) Automatic setup (It will overwrite existing configuration files)"
    echo "2) Manual package selection + selected packages and custom scripts installation"
    echo "3) Install custom scripts only"
    echo "4) Exit"
    echo "5) Reboot"

    read -rp "Enter your choice [1-5]: " choice

    case "$choice" in
        1)
    	sudo pacman -Syu --noconfirm $PACKAGES
        yay -S --noconfirm $PACKAGES_YAY

		sudo mkdir -p /boot/loader/
        sudo cp boot/loader/loader.conf /boot/loader/loader.conf
	
        sudo systemctl enable sddm
        sudo systemctl start sddm

        systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber

        sudo rfkill unblock bluetooth
		sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"

        xdg-mime default mpv.desktop video/mp4
        xdg-mime default mpv.desktop video/x-matroska
        xdg-mime default mpv.desktop video/webm

        sudo systemctl enable --now NetworkManager

        sudo modprobe i2c-dev
        echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
        sudo usermod -aG i2c "$USER"

        sudo systemctl enable --now udisks2
	
		#CONFIGS
	
		cd /Arch_Hyprland_dots/
	
		sudo mkdir -p /usr/share/icons/
        sudo cp -rf .config/ /home/$USER/
        sudo cp -rf themes_bg/modest-dark/ /usr/share/icons/

        hyprctl reload

        sudo mkdir -p /etc/xdg/swaync/
        mkdir -p ~/.local/bin
        sudo cp ~/.config/swaync/style.css /etc/xdg/swaync/style.css
        sudo cp ~/.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
        sudo chmod +x ~/.config/scripts/*.sh
		systemctl --user enable --now swaync
        sudo chmod +x ~/.local/bin/hyprshade-auto.sh

        sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

        sudo chmod +x ~/.config/waybar/scripts/weather.py

        sudo chown -R bob:bob ~/.config/blacklayer/
        chmod 700 ~/.config/blacklayer  
        chmod +x ~/.config/blacklayer/*.sh 2>/dev/null || true
        chmod 600 ~/.config/blacklayer/*.conf 2>/dev/null || true
        [ -f ~/.config/blacklayer/blacklayer ] && chmod +x ~/.config/blacklayer/blacklayer
        sudo chown -R "$USER:$USER" ~/.config/waybar
        chmod 700 ~/.config/waybar  
		cd ~/.config/blacklayer/
        ./generate-waybar-configs.sh

        sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
        sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state
        systemctl --user daemon-reload
        systemctl --user enable --now hyprshade-auto.timer

        sudo chmod 600 ~/.config/scripts/brightness_mode_state
        sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state

		hyprctl reload
		echo -e "${GREEN}Download and installation completed successfully!${NC}"

        MONITORS=$(hyprctl -j monitors | jq -r '.[].name')
        for MONITOR in $MONITORS; do
            echo "Your Monitors:"
            echo "$MONITOR"
        done
        echo "If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"
        echo "Run: ~/.config/scripts/brightness_mode_calib.sh"
        echo "Open your hyprland.conf file to make the necessary changes."
        echo "open your hyprpaper.conf file to make the necessary changes."

		;;

		2)

    	echo -e "${GREEN}Selective install mode${NC}"


		DOWNLOAD_PKGS=()
		SELECTED_PKGS=()
	
		for raw in "${M_PACKAGES[@]}"; do
	
		    if [[ "$raw" == *"("* ]]; then
	
		        main_pkg="${raw%%(*}"
		        inside="${raw#*(}"
		        inside="${inside%)}"
	
		        msg=""
		        deps=""
	
		        # açıklama + dependency birlikte varsa
		        if [[ "$inside" =~ ^\"([^\"]*)\"[[:space:]]*(.*)$ ]]; then
		            msg="${BASH_REMATCH[1]}"
		            deps="${BASH_REMATCH[2]}"
	
		        #sadece dependency varsa
		        else
		            deps="$inside"
		        fi
	
		        deps="$(echo "$deps" | xargs)"
	
		        # kullanıcıya göster
		        if [[ -n "$msg" ]]; then
	
				    if [[ -n "$deps" ]]; then
				        read -rp "$(printf "Select %s\n%s\nPackages to be installed: %s(y/n): " \
				        "$main_pkg" "$(echo -e "$msg")" "$deps")" ans
					    echo
				    else
				        read -rp "$(printf "Select %s\n%s(y/n): " \
				        "$main_pkg" "$(echo -e "$msg")")" ans
					    echo
				    fi
		
				else
				    read -rp "Select $main_pkg ($deps)? (y/n): " ans
				    echo
				fi
	
	
		        if [[ "$ans" =~ ^[Yy]$ ]]; then
		            SELECTED_PKGS+=("$main_pkg")
	
		            if [[ -n "$deps" ]]; then
		                read -ra dep_array <<< "$deps"
		                for dep in "${dep_array[@]}"; do
				    		DOWNLOAD_PKGS+=("$dep|$main_pkg")
						done
		            fi
		        fi
	
		    else
		        read -rp "Select $raw? (y/n): " ans
		        [[ "$ans" =~ ^[Yy]$ ]] && DOWNLOAD_PKGS+=("$raw|")
		    fi
	
		done 

	

		DOWNLOAD_PKGS_AUR=()
		SELECTED_PKGS_AUR=()
	
		for raw in "${M_PACKAGES_YAY[@]}"; do
	
		    if [[ "$raw" == *"("* ]]; then
	
		        main_pkg="${raw%%(*}"
		        inside="${raw#*(}"
		        inside="${inside%)}"
	
		        msg=""
		        deps=""
	
		        # Açıklama + dependency varsa
		        if [[ "$inside" =~ ^\"([^\"]*)\"[[:space:]]*(.*)$ ]]; then
		            msg="${BASH_REMATCH[1]}"
		            deps="${BASH_REMATCH[2]}"
		        else
		            deps="$inside"
		        fi
	
		        deps="$(echo "$deps" | xargs)"
	
		        # Kullanıcıya göster
		        if [[ -n "$msg" ]]; then
	
				    if [[ -n "$deps" ]]; then
				        read -rp "$(printf "Select %s (AUR)\n%s\nPackages to be installed: %s(y/n): " \
				        "$main_pkg" "$(echo -e "$msg")" "$deps")" ans
						echo
				    else
				        read -rp "$(printf "Select %s (AUR)\n%s(y/n): " \
				        "$main_pkg" "$(echo -e "$msg")")" ans
						echo
				    fi
		
				else
				    read -rp "Select $main_pkg ($deps) (AUR)? (y/n): " ans
				    echo
				fi
	
	
		        if [[ "$ans" =~ ^[Yy]$ ]]; then
		            SELECTED_PKGS_AUR+=("$main_pkg")
	
		            if [[ -n "$deps" ]]; then
		                read -ra dep_array <<< "$deps"
		                for dep in "${dep_array[@]}"; do
				    		DOWNLOAD_PKGS_AUR+=("$dep|$main_pkg")
						done
				    fi
			    fi
		
			else
			    read -rp "Select $raw (AUR)? (y/n): " ans
			    [[ "$ans" =~ ^[Yy]$ ]] && DOWNLOAD_PKGS_AUR+=("$raw|")
			fi
		
		done


	
	echo
	echo "The following packages will be installed:"
	echo "-----------------------------------------"

	
	if [[ ${#DOWNLOAD_PKGS[@]} -gt 0 ]]; then
	    echo "pacman:"

	    SEEN_PKGS=()

	    for entry in "${DOWNLOAD_PKGS[@]}"; do
	        pkg="${entry%%|*}"
	        parent="${entry#*|}"

	        already=false
	        seen_parent=""

	        for seen in "${SEEN_PKGS[@]}"; do
	            if [[ "${seen%%|*}" == "$pkg" ]]; then
	                already=true
	                seen_parent="${seen#*|}"
	                break
	            fi
	        done

	        if $already; then
	            if [[ -n "$parent" ]]; then
	                echo -e "  - ${RED}$pkg($parent) Already in download list${NC}"
	            elif [[ -n "$seen_parent" ]]; then
	                echo -e "  - ${RED}$pkg($seen_parent) Already in download list${NC}"
	            else
	                echo -e "  - ${RED}$pkg Already in download list${NC}"
	            fi
	        else
	            if [[ -n "$parent" ]]; then
	                echo "  - $pkg($parent)"
	            else
	                echo "  - $pkg"
	            fi
	            SEEN_PKGS+=("$entry")
	        fi
	    done
	fi



	if [[ ${#DOWNLOAD_PKGS_AUR[@]} -gt 0 ]]; then
	    echo "AUR:"

	    SEEN_PKGS_AUR=()

	    for entry in "${DOWNLOAD_PKGS_AUR[@]}"; do
	        pkg="${entry%%|*}"
	        parent="${entry#*|}"

	        already=false
	        seen_parent=""

	        for seen in "${SEEN_PKGS_AUR[@]}"; do
	            if [[ "${seen%%|*}" == "$pkg" ]]; then
	                already=true
	                seen_parent="${seen#*|}"
	                break
	            fi
	        done

	        if $already; then
	            if [[ -n "$parent" ]]; then
	                echo -e "  - ${RED}$pkg($parent) Already in download list${NC}"
	            elif [[ -n "$seen_parent" ]]; then
	                echo -e "  - ${RED}$pkg($seen_parent) Already in download list${NC}"
	            else
	                echo -e "  - ${RED}$pkg Already in download list${NC}"
	            fi
	        else
	            if [[ -n "$parent" ]]; then
	                echo "  - $pkg($parent)"
	            else
	                echo "  - $pkg"
	            fi
	            SEEN_PKGS_AUR+=("$entry")
	        fi
	    done
	fi


	
	echo
	read -rp "Proceed with installation? (y/n): " confirm

	if [[ "$confirm" =~ ^[Yy]$ ]]; then
	    if [[ ${#DOWNLOAD_PKGS[@]} -gt 0 ]]; then
	        for pkg in "${DOWNLOAD_PKGS[@]}"; do
	            real_pkg="${pkg%%|*}"   # | sonrası atılır
	            sudo pacman -S --needed "$real_pkg"
	        done
	    fi

	    if [[ ${#DOWNLOAD_PKGS_AUR[@]} -gt 0 ]]; then
	        for pkg in "${DOWNLOAD_PKGS_AUR[@]}"; do
	            real_pkg="${pkg%%|*}"   # | sonrası atılır
	            yay -S --needed "$real_pkg"
	        done
	    fi
	else
	    echo "Installation cancelled."
	fi



	# CONFIGS

	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "sddm"
    then
        echo "sddm package selected, running extra configuration..."
	    sudo systemctl enable sddm
        sudo systemctl start sddm
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "audio-pkgs"
	then
	    echo "Audio package selected, running extra configuration..."
	    systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber
	fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "bluetooth-pkgs"
	then
	    echo "Bluetooth package selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
	    sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
	fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "media-player-pkgs"
    then
        echo "Media-player package selected, running extra configuration..."
        xdg-mime default mpv.desktop video/mp4
        xdg-mime default mpv.desktop video/x-matroska
        xdg-mime default mpv.desktop video/webm
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "networkmanager"
    then
        echo "networkmanager package selected, running extra configuration..."
        sudo systemctl enable --now NetworkManager
	fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "udisk"
    then
        echo "udisk package selected, running extra configuration..."
        sudo systemctl enable --now udisks2
    fi

	#SPECIAL CONFIG DOCS

	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprland"
    then
        echo "hyprland package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprland.conf /home/$USER/.config/hypr/hyprland.conf
      	HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Open your hyprland.conf file to make the necessary changes."$'\n'	
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprlock"
    then
        echo "hyprlock package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprlock.conf /home/$USER/.config/hypr/hyprlock.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprpaper"
    then
        echo "hyprpaper package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprpaper.conf /home/$USER/.config/hypr/hyprpaper.conf
	    sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="open your hyprpaper.conf file to make the necessary changes."$'\n'
    fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "kitty"
    then
        echo "kitty package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/kitty
        sudo cp -rf .config/kitty/* /home/$USER/.config/kitty
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "rofi"
    then
        echo "rofi package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/rofi
        sudo cp -rf .config/rofi/* /home/$USER/.config/rofi
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "swaync"
    then
        echo "swaync package selected, running extra configuration..."
        sudo mkdir -p /etc/xdg/swaync/
        sudo cp -f .config/swaync/style.css /etc/xdg/swaync/style.css
	    sudo cp -f .config/swaync/configSchema.json /etc/xdg/swaync/configSchema.json
	    sudo cp -f .config/swaync/config.json ~/.config/swaync/config.json
	    sudo chmod +x ~/.config/scripts/*.sh
	    systemctl --user enable --now swaync
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "waybar"
    then
        echo "waybar package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/waybar
        sudo cp -rf .config/waybar/* /home/$USER/.config/waybar
	    sudo chmod +x ~/.config/waybar/scripts/weather.py
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "wlogout"
    then
        echo "wlogout package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/wlogout
        sudo cp -rf .config/wlogout/* /home/$USER/.config/wlogout
    fi


	#/SCRIPTS
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bootloader"
    then
        echo "script-bootloader config file selected, running extra configuration..."
        sudo mkdir -p /boot/loader/
        sudo cp -f boot/loader/loader.conf /boot/loader/loader.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-keyboard-language"
    then
        echo "script-keyboard-language config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/autostart/
        sudo cp -f .config/autostart/klavye_degistirme.desktop ~/.config/autostart/klavye_degistirme.desktop
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-brightness-control"
    then
        echo "script-brightness-control package selected, running extra configuration..."
	    sudo modprobe i2c-dev
       	echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
        sudo usermod -aG i2c "$USER"
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f .config/scripts/brightness_mode.sh ~/.config/scripts/brightness_mode.sh
	    sudo cp -f .config/scripts/brightness_mode_calib.sh ~/.config/scripts/brightness_mode_calib.sh
	    sudo cp -f .config/scripts/brightness_mode_state ~/.config/scripts/brightness_mode_state
	    sudo cp -f .config/scripts/ddc-map.conf ~/.config/scripts/ddc-map.conf
	    sudo chmod 600 ~/.config/scripts/brightness_mode_state
      	sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state
       	sudo chmod +x ~/.config/scripts/*.sh
	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Run: ~/.config/scripts/brightness_mode_calib.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-hyprshade"
    then
        echo "script-hyprshade config file selected, running extra configuration..."
        mkdir -p ~/.local/bin
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f .config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
	    sudo cp -f .config/scripts/hyprshade-toggle-state ~/.config/scripts/hyprshade-toggle-state
	    sudo cp -f .config/scripts/night_screen.frag ~/.config/scripts/night_screen.frag
	    sudo chmod +x ~/.config/scripts/*.sh
       	sudo chmod +x ~/.local/bin/hyprshade-auto.sh
	    sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
       	sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state

	    systemctl --user daemon-reload
 	    systemctl --user enable --now hyprshade-auto.timer
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenrec"
    then
        echo "script-screenrec config file selected, running extra configuration..."
	    sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f .config/scripts/screenrec.sh ~/.config/scripts/screenrec.sh
	    sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenprint"
    then
        echo "script-screenprint config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f .config/scripts/screenprint.sh ~/.config/scripts/screenprint.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-wifi"
    then
        echo "script-wifi config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bt"
    then
        echo "script-bt config file selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
        sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-gamemode"
    then
        echo "script-gamemode config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/gamemode.sh ~/.config/scripts/gamemode.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "themes-and-icons"
    then
        echo "themes-and-icons config file selected, running extra configuration..."
	    sudo mkdir -p /usr/share/icons/
        sudo cp -rf themes_bg/modest-dark/ /usr/share/icons/
    fi

	hyprctl reload
	echo -e "${GREEN}Download and installation completed successfully!${NC}"
	if [[ -n "$HINTS" ]]; then
	    echo -e "Hints:\n$HINTS"
	fi


	;;

	
	3)

	echo -e "${GREEN}Selective script mode${NC}"


	DOWNLOAD_PKGS=()
	SELECTED_PKGS=()

	for raw in "${M_PACKAGES[@]}"; do

	    if [[ "$raw" == *"("* ]]; then

	        main_pkg="${raw%%(*}"
	        inside="${raw#*(}"
	        inside="${inside%)}"

	        msg=""
	        deps=""

	        # açıklama + dependency birlikte varsa
	        if [[ "$inside" =~ ^\"([^\"]*)\"[[:space:]]*(.*)$ ]]; then
	            msg="${BASH_REMATCH[1]}"
	            deps="${BASH_REMATCH[2]}"

	        #sadece dependency varsa
	        else
	            deps="$inside"
	        fi

	        deps="$(echo "$deps" | xargs)"

	        # kullanıcıya göster
	        if [[ -n "$msg" ]]; then

			    if [[ -n "$deps" ]]; then
			        read -rp "$(printf "Select %s\n%s\nPackages to be installed: %s(y/n): " \
			        "$main_pkg" "$(echo -e "$msg")" "$deps")" ans
					echo
			    else
			        read -rp "$(printf "Select %s\n%s(y/n): " \
			        "$main_pkg" "$(echo -e "$msg")")" ans
					echo
			    fi
	
			else
			    read -rp "Select $main_pkg ($deps)? (y/n): " ans
			    echo
			fi


	        if [[ "$ans" =~ ^[Yy]$ ]]; then
	            SELECTED_PKGS+=("$main_pkg")

	            if [[ -n "$deps" ]]; then
	                read -ra dep_array <<< "$deps"
	                DOWNLOAD_PKGS+=("${dep_array[@]}")
	            fi
	        fi

	    else
	        read -rp "Select $raw? (y/n): " ans
	        [[ "$ans" =~ ^[Yy]$ ]] && DOWNLOAD_PKGS+=("$raw")
	    fi

	done

	

	DOWNLOAD_PKGS_AUR=()
	SELECTED_PKGS_AUR=()

	for raw in "${M_PACKAGES_YAY[@]}"; do

	    if [[ "$raw" == *"("* ]]; then

	        main_pkg="${raw%%(*}"
	        inside="${raw#*(}"
	        inside="${inside%)}"

	        msg=""
	        deps=""

	        # açıklama + dependency birlikte varsa
	        if [[ "$inside" =~ ^\"([^\"]*)\"[[:space:]]*(.*)$ ]]; then
	            msg="${BASH_REMATCH[1]}"
	            deps="${BASH_REMATCH[2]}"
	        else
	            deps="$inside"
	        fi

	        deps="$(echo "$deps" | xargs)"

	        # kullanıcıya göster
	        if [[ -n "$msg" ]]; then
	            if [[ -n "$deps" ]]; then
	                read -rp "$(printf "Select %s (AUR)\n%s\nPackages to be installed: %s(y/n): " \
	                "$main_pkg" "$(echo -e "$msg")" "$deps")" ans
					echo
	            else
	                read -rp "$(printf "Select %s (AUR)\n%s(y/n): " \
	                "$main_pkg" "$(echo -e "$msg")")" ans
					echo
	            fi
	        else
	            read -rp "Select $main_pkg (AUR) ($deps)? (y/n): " ans
				echo
	        fi

	        if [[ "$ans" =~ ^[Yy]$ ]]; then
	            SELECTED_PKGS_AUR+=("$main_pkg")

	            if [[ -n "$deps" ]]; then
	                read -ra dep_array <<< "$deps"
	                DOWNLOAD_PKGS_AUR+=("${dep_array[@]}")
	            fi
	        fi

	    else
	        read -rp "Select $raw (AUR)? (y/n): " ans
	        [[ "$ans" =~ ^[Yy]$ ]] && DOWNLOAD_PKGS_AUR+=("$raw")
	    fi

	done


	#CONFIGS

	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "sddm"
    then
        echo "sddm package selected, running extra configuration..."
	    sudo systemctl enable sddm
        sudo systemctl start sddm
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "audio-pkgs"
	then
	    echo "Audio package selected, running extra configuration..."
	    systemctl --user enable --now pipewire
        systemctl --user enable --now pipewire-pulse
        systemctl --user enable --now wireplumber
	fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "bluetooth-pkgs"
	then
	    echo "Bluetooth package selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
	    sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
	fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "media-player-pkgs"
    then
        echo "Media-player package selected, running extra configuration..."
        xdg-mime default mpv.desktop video/mp4
        xdg-mime default mpv.desktop video/x-matroska
        xdg-mime default mpv.desktop video/webm
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "networkmanager"
    then
        echo "networkmanager package selected, running extra configuration..."
        sudo systemctl enable --now NetworkManager
	fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "udisk"
    then
        echo "udisk package selected, running extra configuration..."
        sudo systemctl enable --now udisks2
    fi

	#SPECIAL CONFIG DOCS

	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprland"
    then
        echo "hyprland package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprland.conf /home/$USER/.config/hypr/hyprland.conf
      	HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Open your hyprland.conf file to make the necessary changes."$'\n'	
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprlock"
    then
        echo "hyprlock package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprlock.conf /home/$USER/.config/hypr/hyprlock.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprpaper"
    then
        echo "hyprpaper package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f .config/hypr/hyprpaper.conf /home/$USER/.config/hypr/hyprpaper.conf
	    sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="open your hyprpaper.conf file to make the necessary changes."$'\n'
    fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "kitty"
    then
        echo "kitty package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/kitty
        sudo cp -rf .config/kitty/* /home/$USER/.config/kitty
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "rofi"
    then
        echo "rofi package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/rofi
        sudo cp -rf .config/rofi/* /home/$USER/.config/rofi
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "swaync"
    then
        echo "swaync package selected, running extra configuration..."
        sudo mkdir -p /etc/xdg/swaync/
        sudo cp -f .config/swaync/style.css /etc/xdg/swaync/style.css
	    sudo cp -f .config/swaync/configSchema.json /etc/xdg/swaync/configSchema.json
	    sudo cp -f .config/swaync/config.json ~/.config/swaync/config.json
	    sudo chmod +x ~/.config/scripts/*.sh
	    systemctl --user enable --now swaync
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "waybar"
    then
        echo "waybar package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/waybar
        sudo cp -rf .config/waybar/* /home/$USER/.config/waybar
	    sudo chmod +x ~/.config/waybar/scripts/weather.py
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "wlogout"
    then
        echo "wlogout package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/wlogout
        sudo cp -rf .config/wlogout/* /home/$USER/.config/wlogout
    fi


	#/SCRIPTS
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bootloader"
    then
        echo "script-bootloader config file selected, running extra configuration..."
        sudo mkdir -p /boot/loader/
        sudo cp -f boot/loader/loader.conf /boot/loader/loader.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-keyboard-language"
    then
        echo "script-keyboard-language config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/autostart/
        sudo cp -f .config/autostart/klavye_degistirme.desktop ~/.config/autostart/klavye_degistirme.desktop
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-brightness-control"
    then
        echo "script-brightness-control package selected, running extra configuration..."
	    sudo modprobe i2c-dev
       	echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
        sudo usermod -aG i2c "$USER"
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f .config/scripts/brightness_mode.sh ~/.config/scripts/brightness_mode.sh
	    sudo cp -f .config/scripts/brightness_mode_calib.sh ~/.config/scripts/brightness_mode_calib.sh
	    sudo cp -f .config/scripts/brightness_mode_state ~/.config/scripts/brightness_mode_state
	    sudo cp -f .config/scripts/ddc-map.conf ~/.config/scripts/ddc-map.conf
	    sudo chmod 600 ~/.config/scripts/brightness_mode_state
      	sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state
       	sudo chmod +x ~/.config/scripts/*.sh
	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Run: ~/.config/scripts/brightness_mode_calib.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-hyprshade"
    then
        echo "script-hyprshade config file selected, running extra configuration..."
        mkdir -p ~/.local/bin
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f .config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
	    sudo cp -f .config/scripts/hyprshade-toggle-state ~/.config/scripts/hyprshade-toggle-state
	    sudo cp -f .config/scripts/night_screen.frag ~/.config/scripts/night_screen.frag
	    sudo chmod +x ~/.config/scripts/*.sh
       	sudo chmod +x ~/.local/bin/hyprshade-auto.sh
	    sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
       	sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state

	    systemctl --user daemon-reload
 	    systemctl --user enable --now hyprshade-auto.timer
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenrec"
    then
        echo "script-screenrec config file selected, running extra configuration..."
	    sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f .config/scripts/screenrec.sh ~/.config/scripts/screenrec.sh
	    sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenprint"
    then
        echo "script-screenprint config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f .config/scripts/screenprint.sh ~/.config/scripts/screenprint.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-wifi"
    then
        echo "script-wifi config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bt"
    then
        echo "script-bt config file selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
        sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-gamemode"
    then
        echo "script-gamemode config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f .config/scripts/gamemode.sh ~/.config/scripts/gamemode.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "themes-and-icons"
    then
        echo "themes-and-icons config file selected, running extra configuration..."
	    sudo mkdir -p /usr/share/icons/
        sudo cp -rf themes_bg/modest-dark/ /usr/share/icons/
    fi

	hyprctl reload
	echo -e "${GREEN}Download and installation completed successfully!${NC}"
	if [[ -n "$HINTS" ]]; then
	    echo -e "Hints:\n$HINTS"
	fi

	;;


	4)
	# Exit application
    break
    ;;


	5)
	read -rp "Unsaved changes will be lost. Are you sure you want to reboot? (y/n): " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                # Reboot system
                :
            fi
            ;;
        *)
            echo "Invalid option. Please select a number between 1 and 5."
            ;;

    esac
done


else
    echo -e "${RED}Skipping installation.${NC}"
fi
