# Arch_Hyprland_dots 
![Image](https://github.com/user-attachments/assets/881fa71c-82c7-4bff-9d3f-f6d838e971c0)
 
# Basic Apps and Packets (Download Section)

! You can install these packages using at least pacman and yay.  
! I use "+" to separate different packages serving the same purpose.  

Linux Kernel: linux linux-zen  
Lock Screen: hyprlock wlogout  
Greeter: sddm  
Background Manager: hyprpaper  
Wayland Compositor: Hyprland wlroots xdg-desktop-portal-hyprland qt5-graphicaleffects  
Panel/Bar: waybar ttf-twemoji  
System Notification: swaync  
Clipboard: wl-clipboard  
Terminal: kitty  
App Launcher: rofi  
Screen Brightness: gammastep  
Print Screen: grim slurp  
Screen Recorder: wf-recorder  
Video Player: mpv  
File Manager: thunar thunar-archive-plugin thunar-volman xarchiver gparted gvfs udisk2 baobab zip unzip unrar p7zip tar  
Network Manager: networkmanager network-manager-applet  
Download: wget git  
Text Editor: Mousepad VSCodium  
File Thumbnail Viewer: tumbler  
Audio Manager: pipewire pipewire-pulse wireplumber alsa-utils pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia nvidia-settings nvidia-utils+(lib32-nvidia-utils+lib32-libg --> for 32 bits)  
Pdf Viewer: Atril  
Image Viewer: Ristretto  


# Extra Apps (Basic essential apps everyone needs on their PC)

Show System Information: neofetch+fastfetch  
Delete Negligible Packages: bleachbit+contrib  
Iso Image Creator: balena-etcher  
Exif Cleaner: metadata-cleaner  
Local File Transfer: localsend  
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
xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 xfce4-terminal xfce4-notify-plugin xfce4-clipman-plugin xfce4-network-manager  



# Hyprland configration files (Setup Section)

git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git

cd Arch_Hyprland_dots

sudo cp -r .config/ /home/$USER/

sudo cp -r themes_bg/modest-dark/ /usr/share/icons/

sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

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

sudo systemctl enable --now udisks2  

//For automatic Eye Comfort Mode:open this file  .config/systemd/user/gammastep-refresh.service  
1-Control your display_name --> WAYLAND_DISPLAY=wayland-1  
2-Check the (latitude) and (longitude) data --> 41.0:29.0 --> (Istanbul)  
systemctl --user daemon-reload  
systemctl --user enable --now gammastep-refresh.timer  

---

Battery Optimization app --> sudo systemctl enable tlp --now

Portmaster --> sudo systemctl enable --now portmaster  

Waydroid --> sudo systemctl enable --now waydroid-container  

Virt --> sudo systemctl enable --now libvirtd  
Virt --> sudo usermod -aG libvirt $USER

//If you use Flatpak  
sudo systemctl enable --now flatpak-system-helper  
