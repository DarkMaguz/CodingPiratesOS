#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

########################
# Config               #
########################

# Bugfix for handling $PATH where root user is missing the sbin directories.
if [ -z $(echo $PATH | grep sbin) ]; then
  export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
fi

# Name the default user.
stdUser=""

if [ -z "$stdUser" ]; then
  echo "Please configure this script before running it."
  exit
fi

########################
# Base System          #
########################

# Overwrite default mirrors.
echo 'deb http://ftp.dk.debian.org/debian/ buster main contrib non-free
deb-src http://ftp.dk.debian.org/debian/ buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib
deb-src http://security.debian.org/debian-security buster/updates main contrib'> /etc/apt/sources.list

apt update -y
apt upgrade -y

apt install -y \
            task-cinnamon-desktop \
            task-danish \
            task-laptop

apt install -y \
            apt-transport-https \
            dirmngr \
            ca-certificates \
            gnupg2 \
            gpg \
            software-properties-common \
            sudo \
            fakeroot \
            firmware-linux \
            wpasupplicant \
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
\
            nemo \
            baobab \
            sakura \
            dconf-editor \
\
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
\
            libdvd-pkg \
            libopencv-dev \
            libgtkmm-3.0-dev \
            libglibmm-2.4-dev \
\
            virtualbox \
            virtualbox-dkms \
\
            geogebra \
            mathomatic \
            wcalc \
            gnome-calculator \
\
            vlc \
            kdenlive \
            blender \
            gimp \
            inkscape \
            kazam \
\
            arduino \
            scratch \
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
\
            lynx \
            wget \
            curl \
            filezilla \
\
            wireshark-gtk \
            traceroute \
            whois \
            ufw \
            iptraf \
            iftop \
            nmap \
            speedometer \
            speedtest-cli \
\
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
\
            hexchat \
            stellarium \
            nexuiz \
            gnome-games

# Fix bug with borken packages libdvdcss2 and libdvd-pkg.
sudo dpkg-reconfigure libdvd-pkg

########################
# Extra Applications   #
########################
extraApps=""

# Google Chrome.
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main> /etc/apt/sources.list.d/google-chrome.list
extraApps="${extraApps} google-chrome-stable"

# MonoDevelop
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo deb https://download.mono-project.com/repo/debian vs-stretch main> /etc/apt/sources.list.d/mono-official-vs.list
extraApps="${extraApps} mono-devel mono-complete mono-dbg monodevelop"

# Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free> /etc/apt/sources.list.d/spotify.list
extraApps="${extraApps} spotify-client"

# Docker
wget -qO - https://download.docker.com/linux/debian/gpg | apt-key add -
echo deb [arch=amd64] https://download.docker.com/linux/debian buster stable> /etc/apt/sources.list.d/docker.list
extraApps="${extraApps} docker-ce"

# Sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo deb https://download.sublimetext.com/ apt/stable/> /etc/apt/sources.list.d/sublime-text.list
extraApps="${extraApps} sublime-text"

# Skype
wget -qO - https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
echo deb [arch=amd64] https://repo.skype.com/deb stable main> /etc/apt/sources.list.d/skype-stable.list
extraApps="${extraApps} skypeforlinux"

# Node.js
wget -qO - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo "deb https://deb.nodesource.com/node_11.x buster main"> /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/node_11.x$VERSION buster main">> /etc/apt/sources.list.d/nodesource.list
extraApps="${extraApps} nodejs"

apt update -y
apt install -y $extraApps

# Install Firefox.
sh update_firefox.sh

# Install Oracle Java JRE.
sh update_java.sh

# Install Unity.
sh update_unity.sh

# Install graphics drivers.
if [ ! -z "$(lspci | grep NVIDIA)" ]; then
  sudo apt install -y nvidia-driver nvidia-kernel-dkms
fi

if [ ! -z "$(lspci | grep AMD/ATI)" ]; then
  sudo apt install -y firmware-amd-graphics
fi

if [ ! -z "$(lspci | grep Intel | grep 'Wireless\|Advanced-N\|Ultimate-N\|WiFi')" ]; then
  apt install -y firmware-iwlwifi
fi


# Install Steam.
dpkg --add-architecture i386
apt update -y
apt install -y steam:i386

########################
# Setup                #
########################
# Setup sudoers.
usermod -aG sudo $stdUser

# Add $stdUser to 'docker' group.
usermod -aG docker $stdUser

# Setup Uncomplicated Firewall (ufw).
ufw enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw reload

########################
# Clean up             #
########################
apt autoremove -y
apt clean
apt autoclean

#apt-get install --no-install-recommends gnome-panel
#gnome-desktop-item-edit --create-new /home/magnus/.local/share/applications/
