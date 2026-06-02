#!/bin/bash
# =============================================================================
# Final Integrated Setup Script: Entertainment & Web Server Edition
# Dijalankan di dalam chroot environment Cubic
# =============================================================================

# Mencegah interaksi "Yes/No" selama instalasi
export DEBIAN_FRONTEND=noninteractive

# Pre-accept lisensi Microsoft Font
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

# -----------------------------------------------------------------------------
# 1. Update Repositori
# -----------------------------------------------------------------------------
apt update
add-apt-repository universe -y
apt update

# -----------------------------------------------------------------------------
# 2. Utilitas & Tools Monitoring
# -----------------------------------------------------------------------------
apt install -y \
    p7zip-full p7zip-rar fastfetch bleachbit timeshift \
    htop net-tools iftop fonts-noto

# -----------------------------------------------------------------------------
# 3. Multimedia & Hiburan
# -----------------------------------------------------------------------------
apt install -y \
    ubuntu-restricted-extras vlc gimp kdenlive obs-studio \
    libreoffice drawing pdfarranger steam-installer lutris retroarch

# Instal Spotify via snap
snap install spotify

# Instal Discord (via .deb)
wget -qO discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb || apt --fix-broken install -y
rm discord.deb

# -----------------------------------------------------------------------------
# 4. Programming (Python, Java, VS Code, NetBeans)
# -----------------------------------------------------------------------------
apt install -y python3 python3-pip python3-venv default-jdk

# NetBeans 29
wget -qO netbeans.deb "https://github.com/codelerity/netbeans-packages/releases/download/v29-build1/apache-netbeans_29-1_amd64.deb"
dpkg -i netbeans.deb || apt --fix-broken install -y
rm netbeans.deb

# VS Code
wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb || apt --fix-broken install -y
rm vscode.deb

# -----------------------------------------------------------------------------
# 5. Web Server & Database (Apache, PHP, MySQL)
# -----------------------------------------------------------------------------
apt install -y apache2 php libapache2-mod-php php-mysql mariadb-server openssh-server ufw certbot python3-certbot-apache

# Konfigurasi UFW (Firewall)
ufw allow OpenSSH
ufw allow 'Apache Full'
# ufw enable (Dijalankan manual nanti)

# Set service agar tidak otomatis jalan saat boot
systemctl disable apache2
systemctl disable mysql
systemctl disable ssh

# -----------------------------------------------------------------------------
# 6. Kustomisasi Visual (Wallpaper & Boot Splash)
# -----------------------------------------------------------------------------
# Wallpaper
cp Bground.png /usr/share/backgrounds/warty-final-ubuntu.png
cp Bground.png /usr/share/backgrounds/ubuntu-wallpaper-d.png
cp Lscreen.png /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png

# Boot Logo (Plymouth)
cp Wmark.png /usr/share/plymouth/themes/spinner/watermark.png
cp logo.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
update-initramfs -u

# -----------------------------------------------------------------------------
# 7. Cleanup
# -----------------------------------------------------------------------------
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
