#!/bin/bash

set -e

CONFIG_DIR="$HOME/.config"
REPO_DIR="$HOME/HYPRLAND"
LISTS_DIR="$HOME/HYPRLAND/lists"

echo "Installing basic tools..."
sudo pacman -S --needed --noconfirm git base-devel

if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git $HOME/yay
    cd $HOME/yay && makepkg -si --noconfirm
    cd $HOME && rm -rf $HOME/yay
fi

echo "Installing pacman packages..."
if [[ -f "$LISTS_DIR/pkglist.txt" ]]; then
    sudo pacman -S --needed --noconfirm $(cat lists/pkglist.txt)
else
    echo "WARNING: pkglist.txt NOT FOUND!"
fi

echo "Installing yay packages..."
if [[ -f "$LISTS_DIR/aur-pkglist.txt" ]]; then
    yay -S --needed --noconfirm $(cat lists/aur-pkglist.txt)
else
    echo "WARNING: aur-pkglist.txt NOT FOUND!"
fi

echo "Creating symbolic links for config files..."

mkdir -p "$CONFIG_DIR"
for folder in "$REPO_DIR"/*/; do
    folder_name=$(basename "$folder")
    
    if [[ "$folder_name" =~ ^(.git|README|LICENSE|scripts|install.sh|lists)$ ]]; then
        continue
    fi
    
    rm -rf "$CONFIG_DIR/$folder_name"
    ln -snf "$folder" "$CONFIG_DIR/$folder_name"
done

sudo ln -snf "$REPO_DIR/ly" /etc/

chsh -s /usr/bin/fish

echo "Enabling/Starting ly display manager"
sudo systemctl enable ly.service
sudo systemctl start ly.service

echo "Setting up wallpaper,fonts,themes,icons..."

hyprpaper -i "$REPO_DIR"/hypr/misc/Fantasy-Landscape.png

gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-pink-standard+default"
if [[ $(gsettings get org.gnome.desktop.interface gtk-theme) != "'catppuccin-mocha-pink-standard+default'" ]]; then
    echo "WARNING: Catppuccin theme might not be installed correctly!"
fi

gsettings set org.gnome.desktop.interface icon-theme "Tela-pink"
if [[ $(gsettings get org.gnome.desktop.interface icon-theme) != "'Tela-pink'" ]]; then
    echo "WARNING: Catppuccin theme might not be installed correctly!"
fi

echo "Installation complete! Restart Hyprland for changes to take effect."