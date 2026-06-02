#!/bin/bash
# =============================================================================
# Ubuntu Entertainment Edition — Setup Script
# =============================================================================

# Pastikan script berjalan di folder tempat file ini berada
cd "$(dirname "$(readlink -f "$0")")"

export DEBIAN_FRONTEND=noninteractive
set -e 

echo "--- Memulai Kustomisasi Ubuntu Entertainment Edition ---"

# 1. Update Sistem
apt update && apt upgrade -y
add-apt-repository universe -y
apt update

# 2. Instal Aplikasi Hiburan (Entertainment)
# Menambahkan: Steam (game), VLC (film), GIMP/Kdenlive (kreatif), 
# Spotify (musik - via snap), RetroArch (game retro)
apt install -y \
    vlc \
    gimp \
    kdenlive \
    libxcb-xtest0 \
    htop \
    fastfetch

# Instal Spotify via snap (standar Ubuntu modern)
snap install spotify

# 3. Kustomisasi Visual (Logo, Watermark, Wallpaper)
echo "Mengganti aset visual tema Entertainment..."

# Wallpaper Desktop
cp background.png /usr/share/backgrounds/warty-final-ubuntu.png
cp background.png /usr/share/backgrounds/ubuntu-wallpaper-d.png

# Wallpaper Lockscreen
cp Lscreen.png /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

# Booting Logo & Watermark
cp waltuhmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp loco.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png

# Update sistem agar perubahan boot tampil
update-initramfs -u

# 4. Memastikan Wallpaper Default Terpasang untuk User Baru
mkdir -p /usr/share/glib-2.0/schemas/
cat <<EOF > /usr/share/glib-2.0/schemas/90_entertainment_edition.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/warty-final-ubuntu.png'
picture-options='zoom'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 5. Cleanup
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*

echo "--- Instalasi Selesai! Ubuntu siap untuk hiburan. ---"
