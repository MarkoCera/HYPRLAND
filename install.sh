#!/bin/bash
sudo pacman -S hyprland wofi dunst fish fastfetch kitty thunar ranger \
    waybar yay grim slurp hyprlock hypridle -y

yay -S vesktop-git spotify ly-git -y








ln -s /home/cera/HYPRLAND/wofi /home/cera/.config/
ln -s /home/cera/HYPRLAND/dunst /home/cera/.config/
ln -s /home/cera/HYPRLAND/fish /home/cera/.config/
ln -s /home/cera/HYPRLAND/fastfetch /home/cera/.config/
ln -s /home/cera/HYPRLAND/gtk-2.0 /home/cera/.config/
ln -s /home/cera/HYPRLAND/gtk-3.0 /home/cera/.config/
ln -s /home/cera/HYPRLAND/kitty /home/cera/.config/
ln -s /home/cera/HYPRLAND/Thunar /home/cera/.config/
ln -s /home/cera/HYPRLAND/ranger /home/cera/.config/
ln -s /home/cera/HYPRLAND/vesktop /home/cera/.config/
ln -s /home/cera/HYPRLAND/spotify /home/cera/.config/
ln -s /home/cera/HYPRLAND/waybar /home/cera/.config/
ln -s /home/cera/HYPRLAND/hypr /home/cera/.config/
sudo ln -s /home/cera/HYPRLAND/ly /etc/
sudo rm -rf /home/cera/.config/hypr && ln -sf /home/cera/HYPRLAND/hypr /home/cera/.config

echo "Installation complete! Restart Hyprland for changes to take effect."

