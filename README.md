# Arch_Hyprland_dots
Hyprland configration files

git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git

cd Arch_Hyprland_dots

sudo cp -r .config/ /home/$USER/

//Configuration for a specific file. sudo cp -r .config/wlogout /home/$USER/.config/

sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

sudo cp  boot/loader/loader.conf /boot/loader/loader.conf

-Basic Apps and Packets-  
sudo pacman -S sddm  
sudo pacman -S nvidia nvidia-utils nvidia-settings lib32-nvidia-utils  
sudo pacman -S grim  
sudo pacman -S slurp  
sudo yay -S swaync  
sudo yay -S wlogout,swaylock  
sudo pacman -S mpv  
sudo pacman -S hyprpaper  
sudo pacman -S kitty  
sudo pacman -S rofi  
sudo yay -S ttf-twemoji  

---

Linux Kernel: linux+linux-zen
Lock Screen: swaylock,wlogout  
Wayland Compositor: Hyprland  
Panel/Bar: waybar  
System Notification: swaync  
Clipboard: wl-clipboard  
Terminal: kitty  
App Launcher: rofi  
Screen Brightness: brightnessctl  
Print Screen: grim  
Video Player: mpv  
File Manager: Thunar+thunar-archive-plugin+thunar-volman+xarchiver+gparted+gvfs+udisk2+baobab+zip+unzip+unrar+p7zip+tar  
Network Manager: networkmanager+network-manager-applet  
Text Editor: Mousepad  
Thumbnail Viewer: Tumbler  
Audio Manager: pipewire+pipewire-pulse+wireplumber+alsa-utils+pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia+nvidia-settings+nvidia-utils+(lib32-nvidia-utils+lib32-libg --> for 32 bits)  
Pdf Viewer:  *Atril
Image Viewer:  *Ristretto

Extras:neofetch+pacman-contrib(delete negligible packages)+balena-etcher(iso)+metadata-cleaner

---

sudo systemctl enable sddm  
sudo systemctl start sddm  

xdg-mime default mpv.desktop video/mp4 
xdg-mime default mpv.desktop video/x-matroska  
xdg-mime default mpv.desktop video/webm  
