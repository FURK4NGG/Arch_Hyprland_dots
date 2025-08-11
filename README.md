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
Thumbnail Viewer: Tumbler  
Audio Manager: pipewire+pipewire-pulse+wireplumber+alsa-utils+pavucontrol  
Packet Manager: pacman+yay+flatpak  
Nvidia Drivers: nvidia+nvidia-settings+nvidia-utils+(lib32-nvidia-utils+lib32-libg --> for 32 bits)  
Pdf Viewer: Atril  
Image Viewer: Ristretto  

Extras:neofetch+,ontrib(delete negligible packages),balena-etcher(iso image creator),metadata-cleaner,switcheroo(image converter),timeshift(snapshot),easyeffects(mic audio effects),gamescope(AI-powered FPS boosting),bottles(windows app runner),piper(Drivers and app manager for Logitech producs),playlist-dl(Youtube Playlist Downloader),textpieces(premium text settings),hypnotix(M3U Provider)

---

sudo systemctl enable sddm  
sudo systemctl start sddm  

xdg-mime default mpv.desktop video/mp4 
xdg-mime default mpv.desktop video/x-matroska  
xdg-mime default mpv.desktop video/webm  
