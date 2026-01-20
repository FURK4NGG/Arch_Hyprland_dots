# Arch_Hyprland_dots 
![Image](https://github.com/user-attachments/assets/b0f8cb38-2818-483d-a036-86c0aa992017)  
 
# Basic Apps and Packets (Download Section)

! You can install these packages using at least pacman and yay.  
! I use "+" to separate different packages serving the same purpose.That means choosing just one of them is enough.  

Linux Kernel: linux+linux-zen  
Lock Screen: hyprlock wlogout  
Greeter: sddm  
Background Manager: hyprpaper  
Wayland Compositor: hyprland wlroots xdg-desktop-portal-hyprland qt5-graphicaleffects  
Panel/Bar: waybar ttf-twemoji  
System Notification: swaync  
Clipboard: wl-clipboard  
Non-Permanent Deletion Utility: trash-cli  
Terminal: kitty  
Resource Monitor: btop  
App Launcher: rofi  
Screen Brightness: hyprshade  
Print Screen: grim slurp  
Screen Recorder: wf-recorder  
Video Player: mpv  
Pdf Viewer: atril  
Image Viewer: ristretto  
Color Picker: hyprpicker  
File Manager: thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar  
Network Manager: networkmanager network-manager-applet  
Bluetooth: bluez bluez-utils blueman  
Download: wget git  
Text Editor: mousepad vscodium  
File Thumbnail Viewer: tumbler  
Audio Manager: pipewire pipewire-pulse wireplumber alsa-utils pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia nvidia-settings nvidia-utils+(lib32-nvidia-utils lib32-libg --> for 32 bits)  


# Extra Apps (Basic essential apps everyone needs on their PC)

Blacklayer: gtk3 gdk-pixbuf2 gtk-layer-shell jq  
Show System Information: neofetch+fastfetch  
Delete Negligible Packages: bleachbit+contrib  
Iso Image Creator: balena-etcher  
Exif Cleaner: metadata-cleaner  
Local File Transfer: localsend-bin  
Image Converter: switcheroo  
Windows App Runner on Linux: bottles  
Driver and App Manager for Logitech Producs: piper  
Youtube Playlist Downloader: playlist-dl  
Premium Text Settings for Developers: textpieces  
M3U Provider: hypnotix  
Snapshot: timeshift  
Mic and Audio Effects: easyeffects  

Battery Optimization is Especially Important for Laptops : tlp tlpui  
Portmaster(for DNS and Ports): portmaster  
Waydroid(Android in a Linux container): waydroid linux-headers waydroid-image  
Virt(Virtual Machine): virt-manager qemu-full vde2 ebtables dnsmasq bridge-utils openbsd-netcat  
Gamescope(AI-Powered FPS Boosting): gamescope  

---

# For Extra XFCE Desktop  
xfce  
xfce4-panel  
xfce4-session  
xfce4-settings  
xfce4-terminal  
xfdesktop  
xfconf  
xfwm4  
xfce4-notifyd  
xfce4-clipman-plugin   
xorg  
xorg-server  
xorg-xinit  
xorg-xinput  
xorg-xrandr



# Hyprland configration files (Setup Section)  

sudo pacman -Syu git  

git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git  

cd Arch_Hyprland_dots  

sudo cp -r .config/ /home/$USER/  

sudo cp -r themes_bg/modest-dark/ /usr/share/icons/  

sudo mkdir /etc/xdg/swaync/  
mkdir -p ~/.local/bin  
sudo cp ~/.config/swaync/style.css /etc/xdg/swaync/style.css  
sudo cp ~/.config/scripts/hyprshade-auto.sh ~/.local/bin/hyprshade-auto.sh  
sudo chmod +x ~/.config/scripts/*.sh  
chmod +x ~/.local/bin/hyprshade-auto.sh  

sudo mkdir /home/$USER/Resimler/wallpapers/  
sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png  

sudo mkdir /boot/loader/  
sudo cp  boot/loader/loader.conf /boot/loader/loader.conf  

//If you just take one specific file.  
//sudo cp -r .config/wlogout /home/$USER/.config/  

sudo systemctl enable sddm  
sudo systemctl start sddm  

systemctl --user enable --now pipewire  
systemctl --user enable --now pipewire-pulse  
systemctl --user enable --now wireplumber  

xdg-mime default mpv.desktop video/mp4  
xdg-mime default mpv.desktop video/x-matroska  
xdg-mime default mpv.desktop video/webm  

sudo systemctl enable --now NetworkManager  
sudo rfkill unblock bluetooth  
sudo systemctl enable --now bluetooth  
sudo usermod -aG bluetooth $USER  

sudo systemctl enable --now udisks2  

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

---

Battery Optimization app --> sudo systemctl enable tlp --now

Portmaster --> sudo systemctl enable --now portmaster  

Waydroid --> sudo systemctl enable --now waydroid-container  

Virt --> sudo systemctl enable --now libvirtd  
Virt --> sudo usermod -aG libvirt $USER

//If you use Flatpak  
sudo systemctl enable --now flatpak-system-helper  

# Fast Installation  
sudo pacman -Syu git  
git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git  
cd Arch_Hyprland_dots  
chmod +x install.sh  
./install.sh  
