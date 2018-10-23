#!/bin/sh -e
echo "Please setup this script before running it!"
exit
#Bugfix for missing /sbin and /usr/sbin in PATH for root.
export PATH=$PATH:/sbin:/usr/sbin

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

# Name the default user.
stdUser=pirat

########################
# Base System          #
########################

apt update
apt upgrade -y
apt install -y apt-transport-https \
      			dirmngr \
      			ca-certificates \
      			gnupg2 \
            gpg \
      			software-properties-common \
            sudo \
            diffutils \
            bluez \
            dkms \
            ffmpeg \
            flac \
            faad \
            faac \
            x265 \
            x264 \
            libavcodec-dev \
            rar \
            zip \
            unrar \
            unzip \
            p7zip-full \
            p7zip-rar \
            gzip \
            lzma \
            bzip2 \
            tar \
            nemo \
            baobab \
            sakura \
            dconf-editor \
            build-essential \
      			autotools-dev \
      			autoconf \
      			automake \
      			make \
      			g++ \
            gpp \
            gcc \
      			libtool \
      			m4 \
            googletest \
            libgtest-dev \
            cmake \
            clang \
            avrdude \
            avr-libc \
            gcc-avr \
            pkg-config \
            perl \
            nodejs \
            python-all \
            python-pygame \
            python-pip \
            git \
            gitg \
            ruby \
            rake \
            php \
            libdvd-pkg \
      			libopencv-dev \
      			libgtkmm-3.0-dev \
      			libglibmm-2.4-dev \
            virtualbox \
            virtualbox-dkms \
      			geogebra \
      			mathomatic \
      			wcalc \
            gnome-calculator \
            vlc \
            kdenlive \
            blender \
            gimp \
            inkscape \
            kazam \
            arduino \
      			scratch \
            squeak-plugins-scratch \
            squeak-vm \
      			fritzing \
      			idle \
            vim \
            emacs \
            nano \
            less \
            libreoffice \
            gedit \
            ghex \
            sqlitebrowser \
      			lynx \
            wget \
      			curl \
            filezilla \
      			wireshark-gtk \
            traceroute \
            whois \
            ufw \
            iptraf \
            iftop \
            nmap \
            speedometer \
            speedtest-cli \
            htop \
            hardinfo \
            gparted \
            gpart \
            gdisk \
      			psensor \
            hddtemp \
            lm-sensors \
            hplip \
            cpuid \
            gkrellm \
      			openssh-server \
            ntfs-3g \
            hexchat \
      			stellarium \
      			nexuiz \
            gnome-games


# Setup sudoers.
#echo "$stdUser    ALL=(ALL:ALL)NOPASSWD: ALL"> /etc/sudoers.d/$stdUser
#adduser $stdUser sudo
usermod -aG sudo $stdUser

# Setup Uncomplicated Firewall (ufw).
ufw enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw reload

########################
# Extra Applications   #
########################
extraApps=""

# Google Chrome.
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
#echo deb http://dl.google.com/linux/chrome/deb/ stable main> /etc/apt/sources.list.d/google-chrome.list
echo deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main> /etc/apt/sources.list.d/google-chrome.list
extraApps="\${extraApps} google-chrome-stable"

# MonoDevelop
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo deb https://download.mono-project.com/repo/debian vs-stretch main> /etc/apt/sources.list.d/mono-official-vs.list
extraApps="\${extraApps} mono-devel mono-complete mono-dbg monodevelop"

# Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free> /etc/apt/sources.list.d/spotify.list
extraApps="\${extraApps} spotify-client"

# Docker
wget -qO - https://download.docker.com/linux/debian/gpg | apt-key add -
echo deb [arch=amd64] https://download.docker.com/linux/debian buster stable> /etc/apt/sources.list.d/docker.list
extraApps="\${extraApps} docker-ce"

# Sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo deb https://download.sublimetext.com/ apt/stable/> /etc/apt/sources.list.d/sublime-text.list
extraApps="\${extraApps} sublime-text"

# Skype
wget -qO - https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
echo deb [arch=amd64] https://repo.skype.com/deb stable main> /etc/apt/sources.list.d/skype-stable.list
extraApps="\${extraApps} skypeforlinux"

apt update
apt install -y $extraApps

# Add $stdUser to 'docker' group.
usermod -aG docker $stdUser

# Install Firefox.
sh update_firefox.sh
cp ../data/Firefox.desktop /usr/share/applications/Firefox.desktop
FF_PATH=/opt/Mozilla
ln -s $FF_PATH/firefox/browser/chrome/icons/default/default16.png /usr/share/icons/hicolor/16x16/apps/firefox.png
ln -s $FF_PATH/firefox/browser/chrome/icons/default/default32.png /usr/share/icons/hicolor/32x32/apps/firefox.png
ln -s $FF_PATH/firefox/browser/chrome/icons/default/default48.png /usr/share/icons/hicolor/48x48/apps/firefox.png
ln -s $FF_PATH/firefox/browser/chrome/icons/default/default64.png /usr/share/icons/hicolor/64x64/apps/firefox.png
ln -s $FF_PATH/firefox/browser/chrome/icons/default/default128.png /usr/share/icons/hicolor/128x128/apps/firefox.png

# Install Oracle Java JRE.
sh update_java.sh

if [ ! -z "$(lspci | grep NVIDIA)" ]; then
        sudo apt install -y --no-gui nvidia-driver nvidia-kernel-dkms
fi

if [ ! -z "$(lspci | grep AMD/ATI)" ]; then
        sudo apt install -y --no-gui firmware-amd-graphics
fi

#aptitude install nvidia-driver

#apt-get install --no-install-recommends gnome-panel
#gnome-desktop-item-edit --create-new /home/magnus/.local/share/applications/
