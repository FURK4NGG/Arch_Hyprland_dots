![Image](https://github.com/user-attachments/assets/881fa71c-82c7-4bff-9d3f-f6d838e971c0)
# Arch_Hyprland_dots
Hyprland configration files

git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git

cd Arch_Hyprland_dots

sudo cp -r .config/ /home/$USER/

sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

sudo cp  boot/loader/loader.conf /boot/loader/loader.conf

//Configuration for a specific file.  
//sudo cp -r .config/wlogout /home/$USER/.config/  

---

-Basic Apps and Packets-  

You can install these packages using at least pacman and yay.

Linux Kernel: linux linux-zen  
Lock Screen: swaylock wlogout  
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



Extra Apps(Basic essential apps everyone needs on their PC):

Show System Information: neofetch+fastfetch  
Delete Negligible Packages: bleachbit+contrib  
Iso Image Creator: balena-etcher  
Exif Cleaner: metadata-cleaner  
Local File Transfer: localsend  
Image Converter: switcheroo  
Snapshot: timeshift  
Mic and Audio Effects: easyeffects  
Windows App Runner on Linux: bottles  
Driver and App Manager for Logitech Producs: piper  
Youtube Playlist Downloader: playlist-dl  
Premium Text Settings for Developers: textpieces  
M3U Provider: hypnotix  

Battery Optimization is Especially Important for Laptops : tlp tlpui  
Portmaster(for DNS and Ports): portmaster  
Waydroid(Android in a Linux container): waydroid linux-headers waydroid-image  
Virt(Virtual Machine): virt-manager qemu-full vde2 ebtables dnsmasq bridge-utils openbsd-netcat  
Gamescope(AI-Powered FPS Boosting): gamescope  

---

*sudo systemctl enable tlp --now

*sudo systemctl enable --now portmaster  

*sudo systemctl enable --now waydroid-container  

*sudo systemctl enable --now libvirtd  
*sudo usermod -aG libvirt $USER


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

//If you use Flatpak
sudo systemctl enable --now flatpak-system-helper

//For automatic Eye Comfort Mode:open this file  .config/systemd/user/gammastep-refresh.service  
1-Control your display_name --> WAYLAND_DISPLAY=wayland-1  
2-Check the (latitude) and (longitude) data --> 41.0:29.0 --> (Istanbul)  
systemctl --user daemon-reload  
systemctl --user enable --now gammastep-refresh.timer  
