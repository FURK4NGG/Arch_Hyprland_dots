#!/bin/bash

# Renkli yazılar için
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m" # reset

HINTS=""

# Kurulacak paket listesi
PACKAGES="linux linux-zen hyprlock xorg-server xorg-xinput xorg-xinit xorg-xrandr mesa vulkan-radeon libva libva-utils wayland wayland-protocols mesa vulkan-radeon base-devel wlogout greetd greetd-tuigreet trash-cli hyprpaper hyprland xdg-desktop-portal xdg-desktop-portal-hyprland libinput libxkbcommon gtk4 ffmpeg qt5-graphicaleffects ddcutil i2c-tools jq hypridle gtk3 gdk-pixbuf2 gtk-layer-shell python-gobject python-cairo python-pip python-pipx libadwaita waybar ttf-twemoji swaync libnotify wl-clipboard kitty btop rofi grim slurp wf-recorder mpv atril ristretto hyprpicker python-evdev ydotool thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git neovim nodejs npm clang pyright tumbler pipewire pipewire-pulse wireplumber alsa-utils pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin"
PACKAGES_YAY="bluez bluez-utils blueman hyprshade"


M_PACKAGES=(linux linux-zen hyprlock mesa vulkan-radeon libva libva-utils wayland wayland-protocols mesa vulkan-radeon base-devel wlogout trash-cli hyprpaper hyprland xdg-desktop-portal xdg-desktop-portal-hyprland libinput libxkbcommon qt5-graphicaleffects jq hypridle gtk3 gdk-pixbuf2 gtk-layer-shell waybar ttf-twemoji swaync wl-clipboard kitty btop rofi atril ristretto hyprpicker thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar networkmanager network-manager-applet wget git mousepad tumbler pavucontrol pacman yay flatpak nvidia nvidia-settings nvidia-utils
'login-manager(greetd greetd-tuigreet)'
'neovim(neovim nodejs npm clang pyright)'
'xfce-desktop("Easy setup for XFCE Desktop" thunar thunar-volman thunar-archive-plugin xarchiver mesa xorg-server xorg-xinput xorg-xinit xorg-xrandr xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notifyd xfce4-notify-plugin xfce4-clipman-plugin libinput libxkbcommon gtk3 gdk-pixbuf2 tumbler gvfs networkmanager network-manager-applet)'
'gaming-stack(mesa vulkan-radeon libva libva-utils nvidia nvidia-settings nvidia-utils wine winetricks lutris steam gamemode mangohud)'
'script-bootloader("Set your boot time to 8 second")'
'script-keyboard-language("A program that switches between the keyboard layouts(US:TR) using the Alt + Shift keys\nRecommended for XFCE desktop environments")'
'script-brightness-control("This package allows you to control your screen brightness using five different modes\nDesigned for Sway, but can also be controlled through the terminal." ddcutil i2c-tools libnotify)'
'screenrec("This package for recording the screen\nDesigned for Sway, but can also be controlled through the terminal." git python python-gobject python-cairo python-evdev gtk4 libadwaita ffmpeg wf-recorder slurp libnotify jq)'
'script-screenprint("This package for take screenshot of the screen\nDesigned for Sway, but can also be controlled through the terminal." grim slurp libnotify)'
'script-wifi("Wifi control with sway\nDesigned for Sway, but can also be controlled through the terminal." networkmanager network-manager-applet)'
'script-vpn("For connect the vpn server, you can follow the instructions in https://github.com/FURK4NGG/Server-Setup or https://git.furk4ngg.me/furk4ngg/Server-Setup" networkmanager wireguard-tools libnotify)'
'script-keyboard-mouse("This package allows you to control the mouse entirely with the keyboard, eliminating the need for a physical mouse." python-evdev ydotool libnotify)'
'blacklayer("A lightweight desktop inactivity tool featuring customizable backgrounds, automatic logout or screen shutdown, and support for custom Python widgets, animations, and per-monitor inactivity monitoring." gtk3 gdk-pixbuf2 gtk-layer-shell jq python python-gobject python-evdev libadwaita)'
'usage-tracker("A lightweight application usage tracker for Linux that monitors active application usage and displays daily usage statistics through a GTK4-based widget." python-gobject gtk4 gtk4-layer-shell jq libnotify)'
'script-gamemode("Improves performance by temporarily disabling unused system features while gaming" libnotify)'
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
	
        sudo mkdir -p /etc/greetd/
		sudo cp -f ./etc/greetd/config.toml /etc/greetd/config.toml
		sudo systemctl enable greetd

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
	
		cd ./Arch_Hyprland_dots/
	
		sudo mkdir -p /usr/share/icons/
        sudo cp -rf ./.config/ /home/$USER/
        sudo cp -rf ./themes_bg/modest-dark/ /usr/share/icons/

        hyprctl reload
		mkdir -p ~/.local/bin
		sudo mkdir -p ~/.config/scripts/
		sudo chmod +x ~/.config/scripts/*.sh

		sudo mkdir -p /etc/xdg/swaync/
		sudo mkdir -p /home/$USER/.config/swaync
        sudo cp -f ./.config/swaync/style.css /etc/xdg/swaync/style.css
	    sudo cp -f ./.config/swaync/configSchema.json /etc/xdg/swaync/configSchema.json
	    sudo cp -f ./.config/swaync/config.json ~/.config/swaync/config.json
	    systemctl --user enable --now swaync

        sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp -f themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

        sudo chmod +x ~/.config/waybar/scripts/weather.py

		
		sudo mkdir -p ~/.config/screenrec/
		sudo mkdir -p ~/Resimler/
		sudo cp -f ./.config/screenrec/screenrec-ui.py ~/.config/screenrec/screenrec-ui.py
		sudo cp -f ./.config/screenrec/screenrec.sh ~/.config/screenrec/screenrec.sh
	    
		chmod +x ~/.config/screenrec/screenrec-ui.py  
		chmod +x ~/.config/screenrec/screenrec.sh  
		chmod +x ~/.config/screenrec/install.sh  
		

		sudo mkdir -p ~/.config/keyboard-mouse/
		systemctl --user enable --now ydotool.service
		sudo usermod -aG input "$USER"
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse.sh ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-ui.py ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-daemon.py ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		~/.config/keyboard-mouse/keyboard-mouse.sh daemon


        sudo mkdir -p ~/.config/blacklayer/
		sudo cp -f ./.config/blacklayer/blacklayer ~/.config/blacklayer/blacklayer
		sudo cp -f ./.config/blacklayer/blacklayer.c ~/.config/blacklayer/blacklayer.c
		sudo cp -f ./.config/blacklayer/blacklayer.conf ~/.config/blacklayer/blacklayer.conf
		sudo cp -f ./.config/blacklayer/blacklayer-worker.sh ~/.config/blacklayer/blacklayer-worker.sh
		sudo cp -f ./.config/blacklayer/clock-widget.py ~/.config/blacklayer/clock-widget.py
		sudo cp -f ./.config/blacklayer/input-activity.py ~/.config/blacklayer/input-activity.py
		sudo cp -f ./.config/blacklayer/blacklayer-ui.py ~/.config/blacklayer/blacklayer-ui.py
		sudo cp -f ./.config/blacklayer/start-waybars.sh ~/.config/blacklayer/start-waybars.sh
		sudo cp -f ./.config/blacklayer/generate-waybar-configs.sh ~/.config/blacklayer/generate-waybar-configs.sh
        
		sudo chown -R "$USER:$USER" ~/.config/blacklayer/
		chmod 700 ~/.config/blacklayer
		chmod +x \
		    ~/.config/blacklayer/blacklayer \
		    ~/.config/blacklayer/blacklayer-worker.sh \
		    ~/.config/blacklayer/clock-widget.py \
		    ~/.config/blacklayer/input-activity.py \
		    ~/.config/blacklayer/blacklayer-ui.py \
		    ~/.config/blacklayer/start-waybars.sh \
		    ~/.config/blacklayer/generate-waybar-configs.sh
		
		chmod 600 ~/.config/blacklayer/blacklayer.conf
		mkdir -p ~/.config/blacklayer/.blacklayer_state/pids
		mkdir -p ~/.config/blacklayer/.blacklayer_state/waybar
		chmod 700 ~/.config/blacklayer/.blacklayer_state
		chmod 700 ~/.config/blacklayer/.blacklayer_state/pids
		chmod 700 ~/.config/blacklayer/.blacklayer_state/waybar

		HINTS+="If you want to disappear waybar(for use 100% of screen) when blacklayer is active follow these steps:"$'\n'
        HINTS+="Run: sudo chown -R "$USER:$USER" ~/.config/waybar"$'\n'
		HINTS+="Run: chmod 700 ~/.config/waybar"$'\n'
		HINTS+="Run: cd ~/.config/blacklayer/"$'\n'
		HINTS+="Run: ./generate-waybar-configs.sh"$'\n'


		mkdir -p ~/.config/usage-tracker/
		sudo cp -f ./.config/usage-tracker/usage-tracker.py ~/.config/usage-tracker/usage-tracker.py
		sudo cp -f ./.config/usage-tracker/usage-tracker.service ~/.config/usage-tracker/usage-tracker.service
		sudo cp -f ./.config/usage-tracker/usage-widget.py ~/.config/usage-tracker/usage-widget.py
		
		chmod +x ~/.config/usage-tracker/usage-widget.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.service  
		systemctl --user daemon-reload  
		systemctl --user enable --now usage-tracker.service  
		
		
		sudo cp -f ./.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
		sudo chmod +x ~/.local/bin/hyprshade-auto.sh
		sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
		sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state
		systemctl --user daemon-reload
		systemctl --user enable --now hyprshade-auto.timer

        sudo chmod 600 ~/.config/scripts/brightness_mode_state
        sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state

		hyprctl reload
		hyprctl configerrors
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
        sudo cp -f ./.config/hypr/hyprland.conf /home/$USER/.config/hypr/hyprland.conf
      	HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Open your hyprland.conf file to make the necessary changes."$'\n'	
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprlock"
    then
        echo "hyprlock package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f ./.config/hypr/hyprlock.conf /home/$USER/.config/hypr/hyprlock.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprpaper"
    then
        echo "hyprpaper package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f ./.config/hypr/hyprpaper.conf /home/$USER/.config/hypr/hyprpaper.conf
	    sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="open your hyprpaper.conf file to make the necessary changes."$'\n'
    fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "kitty"
    then
        echo "kitty package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/kitty
        sudo cp -rf ./.config/kitty/* /home/$USER/.config/kitty
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "neovim"
    then
        echo "neovim package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/nvim/
        sudo cp -f ./.config/nvim/init.lua /home/$USER/.config/nvim/init.lua
		sudo npm install -g typescript typescript-language-server
		sudo npm install -g vscode-langservers-extracted
		echo 'export EDITOR=nvim' >> ~/.bashrc && source ~/.bashrc
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "rofi"
    then
        echo "rofi package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/rofi
        sudo cp -rf ./.config/rofi/* /home/$USER/.config/rofi
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "swaync"
    then
        echo "swaync package selected, running extra configuration..."
        sudo mkdir -p /etc/xdg/swaync/
		sudo mkdir -p /home/$USER/.config/swaync
        sudo cp -f ./.config/swaync/style.css /etc/xdg/swaync/style.css
	    sudo cp -f ./.config/swaync/configSchema.json /etc/xdg/swaync/configSchema.json
	    sudo cp -f ./.config/swaync/config.json ~/.config/swaync/config.json
	    systemctl --user enable --now swaync
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "waybar"
    then
        echo "waybar package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/waybar
        sudo cp -rf ./.config/waybar/* /home/$USER/.config/waybar
	    sudo chmod +x ~/.config/waybar/scripts/weather.py
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "wlogout"
    then
        echo "wlogout package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/wlogout
        sudo cp -rf ./.config/wlogout/* /home/$USER/.config/wlogout
    fi


	#/SCRIPTS
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "login-manager"
    then
        echo "login-manager package selected, running extra configuration..."
		sudo mkdir -p /etc/greetd/
		sudo cp -f ./etc/greetd/config.toml /etc/greetd/config.toml
		sudo systemctl enable greetd
    fi


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
        sudo cp -f ./.config/autostart/klavye_degistirme.desktop ~/.config/autostart/klavye_degistirme.desktop
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-brightness-control"
    then
        echo "script-brightness-control package selected, running extra configuration..."
	    sudo modprobe i2c-dev
       	echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
        sudo usermod -aG i2c "$USER"
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f ./.config/scripts/brightness_mode.sh ~/.config/scripts/brightness_mode.sh
	    sudo cp -f ./.config/scripts/brightness_mode_calib.sh ~/.config/scripts/brightness_mode_calib.sh
	    sudo cp -f ./.config/scripts/brightness_mode_state ~/.config/scripts/brightness_mode_state
	    sudo cp -f ./.config/scripts/ddc-map.conf ~/.config/scripts/ddc-map.conf
	    sudo chmod 600 ~/.config/scripts/brightness_mode_state
      	sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state
       	sudo chmod +x ~/.config/scripts/*.sh
	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Run: ~/.config/scripts/brightness_mode_calib.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-hyprshade"
    then
        echo "script-hyprshade config file selected, running extra configuration..."
		sudo pacman -S --needed --noconfirm python-pip python-pipx
        mkdir -p ~/.local/bin
	    sudo mkdir -p ~/.config/scripts/
	    sudo chmod +x ~/.config/scripts/*.sh
       	
		sudo cp -f ./.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
		sudo chmod +x ~/.local/bin/hyprshade-auto.sh
		sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
		sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state
		systemctl --user daemon-reload
		systemctl --user enable --now hyprshade-auto.timer
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "screenrec"
    then
        echo "screenrec config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/screenrec/
		sudo mkdir -p ~/Resimler/
		sudo cp -f ./.config/screenrec/screenrec-ui.py ~/.config/screenrec/screenrec-ui.py
		sudo cp -f ./.config/screenrec/screenrec.sh ~/.config/screenrec/screenrec.sh
	    
		chmod +x ~/.config/screenrec/screenrec-ui.py  
		chmod +x ~/.config/screenrec/screenrec.sh  
		chmod +x ~/.config/screenrec/install.sh  
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenprint"
    then
        echo "script-screenprint config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f ./.config/scripts/screenprint.sh ~/.config/scripts/screenprint.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-wifi"
    then
        echo "script-wifi config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-vpn"
    then
        echo "script-vpn config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/vpn.sh ~/.config/scripts/vpn.sh
        sudo chmod +x ~/.config/scripts/*.sh

		echo "Checking NetworkManager..."
	    systemctl is-active --quiet NetworkManager.service \
	        && echo "NetworkManager is running." \
	        || echo "NetworkManager failed to start."
	
	    echo "Checking WireGuard tools..."
	    command -v nmcli >/dev/null \
	        && echo "nmcli is installed."
	
	    command -v wg >/dev/null \
	        && echo "wg is installed."
	
	    command -v wg-quick >/dev/null \
	        && echo "wg-quick is installed."
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-keyboard-mouse"
    then
        echo "script-keyboard-mouse config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/keyboard-mouse/
	    systemctl --user enable --now ydotool.service
		sudo usermod -aG input "$USER"
        sudo cp -f ./.config/keyboard-mouse/keyboard-mouse.sh ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-ui.py ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-daemon.py ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse.sh
		~/.config/keyboard-mouse/keyboard-mouse.sh daemon
		hyprctl reload
		hyprctl configerrors
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "blacklayer"
    then
		echo "blacklayer config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/blacklayer/
		sudo cp -f ./.config/blacklayer/blacklayer ~/.config/blacklayer/blacklayer
		sudo cp -f ./.config/blacklayer/blacklayer.c ~/.config/blacklayer/blacklayer.c
		sudo cp -f ./.config/blacklayer/blacklayer.conf ~/.config/blacklayer/blacklayer.conf
		sudo cp -f ./.config/blacklayer/blacklayer-worker.sh ~/.config/blacklayer/blacklayer-worker.sh
		sudo cp -f ./.config/blacklayer/clock-widget.py ~/.config/blacklayer/clock-widget.py
		sudo cp -f ./.config/blacklayer/input-activity.py ~/.config/blacklayer/input-activity.py
		sudo cp -f ./.config/blacklayer/blacklayer-ui.py ~/.config/blacklayer/blacklayer-ui.py
		sudo cp -f ./.config/blacklayer/start-waybars.sh ~/.config/blacklayer/start-waybars.sh
		sudo cp -f ./.config/blacklayer/generate-waybar-configs.sh ~/.config/blacklayer/generate-waybar-configs.sh
        
		sudo chown -R "$USER:$USER" ~/.config/blacklayer/
		chmod 700 ~/.config/blacklayer
		chmod +x \
		    ~/.config/blacklayer/blacklayer \
		    ~/.config/blacklayer/blacklayer-worker.sh \
		    ~/.config/blacklayer/clock-widget.py \
		    ~/.config/blacklayer/input-activity.py \
		    ~/.config/blacklayer/blacklayer-ui.py \
		    ~/.config/blacklayer/start-waybars.sh \
		    ~/.config/blacklayer/generate-waybar-configs.sh
		
		chmod 600 ~/.config/blacklayer/blacklayer.conf
		mkdir -p ~/.config/blacklayer/.blacklayer_state/pids
		mkdir -p ~/.config/blacklayer/.blacklayer_state/waybar
		chmod 700 ~/.config/blacklayer/.blacklayer_state
		chmod 700 ~/.config/blacklayer/.blacklayer_state/pids
		chmod 700 ~/.config/blacklayer/.blacklayer_state/waybar

		HINTS+="If you want to disappear waybar(for use 100% of screen) when blacklayer is active follow these steps:"$'\n'
        HINTS+="Run: sudo chown -R "$USER:$USER" ~/.config/waybar"$'\n'
		HINTS+="Run: chmod 700 ~/.config/waybar"$'\n'
		HINTS+="Run: cd ~/.config/blacklayer/"$'\n'
		HINTS+="Run: ./generate-waybar-configs.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "usage-tracker"
    then
        echo "usage-tracker config file selected, running extra configuration..."
	    mkdir -p ~/.config/usage-tracker/
		sudo cp -f ./.config/usage-tracker/usage-tracker.py ~/.config/usage-tracker/usage-tracker.py
		sudo cp -f ./.config/usage-tracker/usage-tracker.service ~/.config/usage-tracker/usage-tracker.service
		sudo cp -f ./.config/usage-tracker/usage-widget.py ~/.config/usage-tracker/usage-widget.py
		
		chmod +x ~/.config/usage-tracker/usage-widget.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.service  
		systemctl --user daemon-reload  
		systemctl --user enable --now usage-tracker.service  
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bt"
    then
        echo "script-bt config file selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
        sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-gamemode"
    then
        echo "script-gamemode config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/gamemode.sh ~/.config/scripts/gamemode.sh
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
        sudo cp -f ./.config/hypr/hyprland.conf /home/$USER/.config/hypr/hyprland.conf
      	HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Open your hyprland.conf file to make the necessary changes."$'\n'	
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprlock"
    then
        echo "hyprlock package selected, running extra configuration..."
	    sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f ./.config/hypr/hyprlock.conf /home/$USER/.config/hypr/hyprlock.conf
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "hyprpaper"
    then
        echo "hyprpaper package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/hypr
        sudo cp -f ./.config/hypr/hyprpaper.conf /home/$USER/.config/hypr/hyprpaper.conf
	    sudo mkdir -p /home/$USER/Resimler/wallpapers/
        sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="open your hyprpaper.conf file to make the necessary changes."$'\n'
    fi

	
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "kitty"
    then
        echo "kitty package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/kitty
        sudo cp -rf ./.config/kitty/* /home/$USER/.config/kitty
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "neovim"
    then
        echo "neovim package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/nvim/
        sudo cp -f ./.config/nvim/init.lua /home/$USER/.config/nvim/init.lua
		sudo npm install -g typescript typescript-language-server
		sudo npm install -g vscode-langservers-extracted
		echo 'export EDITOR=nvim' >> ~/.bashrc && source ~/.bashrc
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "rofi"
    then
        echo "rofi package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/rofi
        sudo cp -rf ./.config/rofi/* /home/$USER/.config/rofi
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "swaync"
    then
        echo "swaync package selected, running extra configuration..."
        sudo mkdir -p /etc/xdg/swaync/
		sudo mkdir -p /home/$USER/.config/swaync
        sudo cp -f ./.config/swaync/style.css /etc/xdg/swaync/style.css
	    sudo cp -f ./.config/swaync/configSchema.json /etc/xdg/swaync/configSchema.json
	    sudo cp -f ./.config/swaync/config.json ~/.config/swaync/config.json
	    systemctl --user enable --now swaync
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "waybar"
    then
        echo "waybar package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/waybar
        sudo cp -rf ./.config/waybar/* /home/$USER/.config/waybar
	    sudo chmod +x ~/.config/waybar/scripts/weather.py
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "wlogout"
    then
        echo "wlogout package selected, running extra configuration..."
        sudo mkdir -p /home/$USER/.config/wlogout
        sudo cp -rf ./.config/wlogout/* /home/$USER/.config/wlogout
    fi


	#/SCRIPTS
	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "login-manager"
    then
        echo "login-manager package selected, running extra configuration..."
		sudo mkdir -p /etc/greetd/
		sudo cp -f ./etc/greetd/config.toml /etc/greetd/config.toml
		sudo systemctl enable greetd
    fi


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
        sudo cp -f ./.config/autostart/klavye_degistirme.desktop ~/.config/autostart/klavye_degistirme.desktop
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-brightness-control"
    then
        echo "script-brightness-control package selected, running extra configuration..."
	    sudo modprobe i2c-dev
       	echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
        sudo usermod -aG i2c "$USER"
	    sudo mkdir -p ~/.config/scripts/
	    sudo cp -f ./.config/scripts/brightness_mode.sh ~/.config/scripts/brightness_mode.sh
	    sudo cp -f ./.config/scripts/brightness_mode_calib.sh ~/.config/scripts/brightness_mode_calib.sh
	    sudo cp -f ./.config/scripts/brightness_mode_state ~/.config/scripts/brightness_mode_state
	    sudo cp -f ./.config/scripts/ddc-map.conf ~/.config/scripts/ddc-map.conf
	    sudo chmod 600 ~/.config/scripts/brightness_mode_state
      	sudo chown $USER:$USER ~/.config/scripts/brightness_mode_state
       	sudo chmod +x ~/.config/scripts/*.sh
	    HINTS+="If your monitors are not named HDMI-A-2 and DP-2, or if you have more than two monitors, follow these steps:"$'\n'
        HINTS+="Run: ~/.config/scripts/brightness_mode_calib.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-hyprshade"
    then
        echo "script-hyprshade config file selected, running extra configuration..."
		sudo pacman -S --needed --noconfirm python-pip python-pipx
        mkdir -p ~/.local/bin
	    sudo mkdir -p ~/.config/scripts/
	    sudo chmod +x ~/.config/scripts/*.sh
       	
		sudo cp -f ./.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh
		sudo chmod +x ~/.local/bin/hyprshade-auto.sh
		sudo chmod 600 ~/.config/scripts/hyprshade-toggle-state
		sudo chown $USER:$USER ~/.config/scripts/hyprshade-toggle-state
		systemctl --user daemon-reload
		systemctl --user enable --now hyprshade-auto.timer
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "screenrec"
    then
        echo "screenrec config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/screenrec/
		sudo mkdir -p ~/Resimler/
		sudo cp -f ./.config/screenrec/screenrec-ui.py ~/.config/screenrec/screenrec-ui.py
		sudo cp -f ./.config/screenrec/screenrec.sh ~/.config/screenrec/screenrec.sh
	    
		chmod +x ~/.config/screenrec/screenrec-ui.py  
		chmod +x ~/.config/screenrec/screenrec.sh  
		chmod +x ~/.config/screenrec/install.sh  
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-screenprint"
    then
        echo "script-screenprint config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
	    sudo mkdir -p ~/Resimler/
        sudo cp -f ./.config/scripts/screenprint.sh ~/.config/scripts/screenprint.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-wifi"
    then
        echo "script-wifi config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-vpn"
    then
        echo "script-vpn config file selected, running extra configuration..."
	    sudo systemctl enable --now NetworkManager
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/vpn.sh ~/.config/scripts/vpn.sh
        sudo chmod +x ~/.config/scripts/*.sh

		echo "Checking NetworkManager..."
	    systemctl is-active --quiet NetworkManager.service \
	        && echo "NetworkManager is running." \
	        || echo "NetworkManager failed to start."
	
	    echo "Checking WireGuard tools..."
	    command -v nmcli >/dev/null \
	        && echo "nmcli is installed."
	
	    command -v wg >/dev/null \
	        && echo "wg is installed."
	
	    command -v wg-quick >/dev/null \
	        && echo "wg-quick is installed."
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-keyboard-mouse"
    then
        echo "script-keyboard-mouse config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/keyboard-mouse/
	    systemctl --user enable --now ydotool.service
		sudo usermod -aG input "$USER"
        sudo cp -f ./.config/keyboard-mouse/keyboard-mouse.sh ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-ui.py ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo cp -f ./.config/keyboard-mouse/keyboard-mouse-daemon.py ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse.sh
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chown "$USER:$USER" ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-daemon.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse-ui.py
		sudo chmod +x ~/.config/keyboard-mouse/keyboard-mouse.sh
		~/.config/keyboard-mouse/keyboard-mouse.sh daemon
		hyprctl reload
		hyprctl configerrors
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "blacklayer"
    then
		echo "blacklayer config file selected, running extra configuration..."
		sudo mkdir -p ~/.config/blacklayer/
		sudo cp -f ./.config/blacklayer/blacklayer ~/.config/blacklayer/blacklayer
		sudo cp -f ./.config/blacklayer/blacklayer.c ~/.config/blacklayer/blacklayer.c
		sudo cp -f ./.config/blacklayer/blacklayer.conf ~/.config/blacklayer/blacklayer.conf
		sudo cp -f ./.config/blacklayer/blacklayer-worker.sh ~/.config/blacklayer/blacklayer-worker.sh
		sudo cp -f ./.config/blacklayer/clock-widget.py ~/.config/blacklayer/clock-widget.py
		sudo cp -f ./.config/blacklayer/input-activity.py ~/.config/blacklayer/input-activity.py
		sudo cp -f ./.config/blacklayer/blacklayer-ui.py ~/.config/blacklayer/blacklayer-ui.py
		sudo cp -f ./.config/blacklayer/start-waybars.sh ~/.config/blacklayer/start-waybars.sh
		sudo cp -f ./.config/blacklayer/generate-waybar-configs.sh ~/.config/blacklayer/generate-waybar-configs.sh
        
		sudo chown -R "$USER:$USER" ~/.config/blacklayer/
		chmod 700 ~/.config/blacklayer
		chmod +x \
		    ~/.config/blacklayer/blacklayer \
		    ~/.config/blacklayer/blacklayer-worker.sh \
		    ~/.config/blacklayer/clock-widget.py \
		    ~/.config/blacklayer/input-activity.py \
		    ~/.config/blacklayer/blacklayer-ui.py \
		    ~/.config/blacklayer/start-waybars.sh \
		    ~/.config/blacklayer/generate-waybar-configs.sh
		
		chmod 600 ~/.config/blacklayer/blacklayer.conf
		mkdir -p ~/.config/blacklayer/.blacklayer_state/pids
		mkdir -p ~/.config/blacklayer/.blacklayer_state/waybar
		chmod 700 ~/.config/blacklayer/.blacklayer_state
		chmod 700 ~/.config/blacklayer/.blacklayer_state/pids
		chmod 700 ~/.config/blacklayer/.blacklayer_state/waybar

		HINTS+="If you want to disappear waybar(for use 100% of screen) when blacklayer is active follow these steps:"$'\n'
        HINTS+="Run: sudo chown -R "$USER:$USER" ~/.config/waybar"$'\n'
		HINTS+="Run: chmod 700 ~/.config/waybar"$'\n'
		HINTS+="Run: cd ~/.config/blacklayer/"$'\n'
		HINTS+="Run: ./generate-waybar-configs.sh"$'\n'
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "usage-tracker"
    then
        echo "usage-tracker config file selected, running extra configuration..."
	    mkdir -p ~/.config/usage-tracker/
		sudo cp -f ./.config/usage-tracker/usage-tracker.py ~/.config/usage-tracker/usage-tracker.py
		sudo cp -f ./.config/usage-tracker/usage-tracker.service ~/.config/usage-tracker/usage-tracker.service
		sudo cp -f ./.config/usage-tracker/usage-widget.py ~/.config/usage-tracker/usage-widget.py
		
		chmod +x ~/.config/usage-tracker/usage-widget.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.py  
		chmod +x ~/.config/usage-tracker/usage-tracker.service  
		systemctl --user daemon-reload  
		systemctl --user enable --now usage-tracker.service  
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-bt"
    then
        echo "script-bt config file selected, running extra configuration..."
	    sudo rfkill unblock bluetooth
        sudo systemctl enable --now bluetooth
        sudo usermod -aG bluetooth "$USER"
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/wifi-bt.sh ~/.config/scripts/wifi-bt.sh
        sudo chmod +x ~/.config/scripts/*.sh
    fi


	if printf '%s\n' "${SELECTED_PKGS[@]}" "${SELECTED_PKGS_AUR[@]}" "${DOWNLOAD_PKGS[@]}" "${DOWNLOAD_PKGS_AUR[@]}" | grep -qx "script-gamemode"
    then
        echo "script-gamemode config file selected, running extra configuration..."
        sudo mkdir -p ~/.config/scripts/
        sudo cp -f ./.config/scripts/gamemode.sh ~/.config/scripts/gamemode.sh
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
