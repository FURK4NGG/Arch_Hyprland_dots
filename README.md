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

Linux Kernel: linux+linux-zen  
Lock Screen: swaylock,wlogout  
Greeter: sddm  
Background Manager: hyprpaper  
Wayland Compositor: Hyprland  
Panel/Bar: waybar,ttf-twemoji  
System Notification: swaync  
Clipboard: wl-clipboard  
Terminal: kitty  
App Launcher: rofi  
Screen Brightness: brightnessctl  
Print Screen: grim,slurp  
Screen Recorder: wf-recorder  
Video Player: mpv  
File Manager: Thunar+thunar-archive-plugin+thunar-volman+xarchiver+gparted+gvfs+udisk2+baobab+zip+unzip+unrar+p7zip+tar  
Network Manager: networkmanager+network-manager-applet  
Text Editor: Mousepad  
File Thumbnail Viewer: Tumbler  
Audio Manager: pipewire+pipewire-pulse+wireplumber+alsa-utils+pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia+nvidia-settings+nvidia-utils+(lib32-nvidia-utils+lib32-libg --> for 32 bits)  
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

PortMaster(for DNS and Ports): portmaster  
Waydroid(Android in a Linux container): waydroid linux-headers waydroid-image  
Virt(Virtual Machine): virt-manager qemu-full vde2 ebtables dnsmasq bridge-utils openbsd-netcat  
GameScope(AI-Powered FPS Boosting): gamescope  

---

*sudo systemctl enable --now portmaster  

*sudo systemctl enable --now waydroid-container  

*sudo systemctl enable --now libvirtd  
*->sudo usermod -aG libvirt $USER


sudo systemctl enable sddm  
sudo systemctl start sddm  

xdg-mime default mpv.desktop video/mp4 
xdg-mime default mpv.desktop video/x-matroska  
xdg-mime default mpv.desktop video/webm  
