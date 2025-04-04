#!/bin/bash

set -e

CONFIG_DIR="$HOME/.config"
REPO_DIR="$HOME/HYPRLAND"
LISTS_DIR="$HOME/HYPRLAND/lists"

update_mirrorlist() {
    echo "Configuring mirror list..."
    
    [[ ! -f /etc/pacman.d/mirrorlist.backup ]] && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    
    sudo curl -s "https://archlinux.org/mirrorlist/all/" -o /etc/pacman.d/mirrorlist
    
    sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
    sudo sort -R /etc/pacman.d/mirrorlist -o /etc/pacman.d/mirrorlist
    
    echo "Mirror list updated successfully!"
}

install_basic_tools() {
    echo "Installing basic tools..."
    sudo pacman -S --needed --noconfirm base-devel &> /dev/null
    sudo pacman -S git --noconfirm
    git config --global http.postBuffer 157286400
}

configure_pacman() {
    echo "Configuring pacman..."
    sudo sed -i 's/^#Color/Color/; s/^#VerbosePkgLists/VerbosePkgLists/; s/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
    sudo pacman -Sy archlinux-keyring --noconfirm 
    sudo pacman -Syu --noconfirm #&> /dev/null
}

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        git clone -q https://aur.archlinux.org/yay.git $HOME/yay &> /dev/null
        cd $HOME/yay && makepkg -si --noconfirm &> /dev/null
        cd $HOME && rm -rf $HOME/yay
    fi
}

install_packages() {
    echo "Installing pacman packages..."
    if [[ -f "$LISTS_DIR/pkglist.txt" && -s "$LISTS_DIR/pkglist.txt" ]]; then
        sudo pacman -S --needed --noconfirm $(cat $LISTS_DIR/pkglist.txt) &> /dev/null
    else
        echo "WARNING: pkglist.txt NOT FOUND!"
    fi

    echo "Installing yay packages..."
    if [[ -f "$LISTS_DIR/aur-pkglist.txt" ]]; then
        yay -S --needed --noconfirm $(cat $LISTS_DIR/aur-pkglist.txt)
    else
        echo "WARNING: aur-pkglist.txt NOT FOUND!"
    fi
}

setup_symlinks() {
    echo "Creating symbolic links for config files..."
    mkdir -p "$CONFIG_DIR"
    for folder in "$REPO_DIR"/*/; do
        folder_name=$(basename "$folder")
        if [[ "$folder_name" =~ ^(.git|README|LICENSE|scripts|install.sh|lists|test.log|starship.toml)$ ]]; then
            continue
        fi
        rm -rf "$CONFIG_DIR/$folder_name" &> /dev/null
        ln -snf "$folder" "$CONFIG_DIR/$folder_name" &> /dev/null
    done
    sudo cp -r "$REPO_DIR/ly" /etc/ &> /dev/null
}

configure_services() {
    echo "Enabling/Starting services"
    sudo systemctl enable ly.service &> /dev/null
    sudo systemctl start ly.service &> /dev/null
    sudo systemctl enable bluetooth.service &> /dev/null
    sudo systemctl start bluetooth.service &> /dev/null
    sudo systemctl enable NetworkManager.service &> /dev/null
    sudo systemctl start NetworkManager.service &> /dev/null
    sudo systemctl enable iwd.service &> /dev/null
    sudo systemctl start iwd.service &> /dev/null
}

setup_desktop_environment() {
    echo "Setting up wallpaper, fonts, themes, icons..."
    hyprpaper -i "$REPO_DIR/hypr/wallpapers/1.png" &> /dev/null
    
    gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-pink-standard+default" &> /dev/null
    if [[ $(gsettings get org.gnome.desktop.interface gtk-theme) != "'catppuccin-mocha-pink-standard+default'" ]]; then
        echo "WARNING: Catppuccin theme might not be installed correctly!"
    fi

    gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-pink-dark" &> /dev/null
    if [[ $(gsettings get org.gnome.desktop.interface icon-theme) != "'Tela-pink-dark'" ]]; then
        echo "WARNING: Tela-pink icon theme might not be installed correctly!"
    fi
}

main() {
    update_mirrorlist
    install_basic_tools
    configure_pacman
    install_yay
    install_packages
    setup_symlinks
    configure_services
    setup_desktop_environment
    echo "Installation complete! Restart Hyprland for changes to take effect."
}

main
