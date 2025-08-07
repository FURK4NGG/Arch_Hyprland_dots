# Arch_Hyprland_dots
Hyprland configration files

git clone https://github.com/furk4ngg/Arch_Hyprland_dots.git

cd Arch_Hyprland_dots

sudo cp -r .config/ /home/$USER/.config/

sudo cp themes_bg/DarkBlue.rasi /usr/share/rofi/themes/DarkBlue.rasi

sudo cp themes_bg/wallpaper-2.png /home/$USER/Resimler/wallpapers/wallpaper-2.png

sudo cp  boot/loader/loader.conf /boot/loader/loader.conf

-Basic Apps and Packets-
sudo pacman -S nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
sudo pacman -S grim
sudo pacman -S slurp

Ekran kilidi	swaylock
*Bildirim	mako veya dunst	Wayland uyumlu
Clipboard	wl-clipboard
Terminal	kitty
Dosya Yöneticisi	thunar
Ağ	networkmanager, nm-applet	
Ses	pipewire, pipewire-pulse, pavucontrol
Ekran Parlaklığı	brightnessctl	
Ekran Görüntüsü	grim
Video Oynatıcı mpv
Panel/Bar	waybar


xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/webm
