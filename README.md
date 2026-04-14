<!-- diger uygulamalarini sun ve paket olarak sor -->
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
Text Editor: neovim vscodium  
File Thumbnail Viewer: tumbler  
Audio Manager: pipewire pipewire-pulse wireplumber alsa-utils pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia nvidia-settings nvidia-utils+(lib32-nvidia-utils lib32-libg --> for 32 bits)  


# Extra Apps (Basic essential apps everyone needs on their PC)

Blacklayer(Screen Saver): gtk3 gdk-pixbuf2 gtk-layer-shell jq hypridle  
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


---

Battery Optimization app --> sudo systemctl enable tlp --now

Portmaster --> sudo systemctl enable --now portmaster  

Waydroid --> sudo systemctl enable --now waydroid-container  

Virt --> sudo systemctl enable --now libvirtd  
Virt --> sudo usermod -aG libvirt $USER

//If you use Flatpak  
sudo systemctl enable --now flatpak-system-helper  

# Fast Installation  
archinstall  
sudo pacman -Syu git  
git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git  
cd Arch_Hyprland_dots  
chmod +x install.sh  
./install.sh  
