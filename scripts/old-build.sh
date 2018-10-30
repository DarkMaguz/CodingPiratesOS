#!/bin/sh -e

if [ ! -d ../distro/ ]; then
	mkdir -p ../distro/
	cd ../distro/
else
	cd ../distro/
	sudo lb clean --all
fi

#sudo apt install live-build build-essential chroot


lb config --apt-indices false \
          --apt-recommends true \
          --apt-source-archives true \
          --architectures amd64 \
          --binary-images iso-hybrid \
          --binary-filesystem fat32 \
          --bootappend-install config hostname=codingpirates \
          --bootappend-live auto=true persistence persistence-media=removable-usb config hostname=codingpirates username=pirat user-fullname="Kaptajn Hack" locales=da_DK.UTF8 timezone=Europe/Copenhagen \
          --bootloader syslinux \
          --cache true \
        	--cache-indices true \
        	--cache-packages true \
        	--cache-stages bootstrap rootfs \
        	--checksums md5 sha1 sha256 \
        	--compression gzip \
        	--build-with-chroot true \
        	--chroot-filesystem ext4 \
          --debconf-frontend noninteractive \
          --debconf-priority critical \
          --debian-installer live \
          --debian-installer-distribution daily \
          --debian-installer-gui false \
          --debug \
          --distribution buster \
        	--parent-distribution buster \
        	--parent-debian-installer-distribution buster \
          --grub-splash ./config/bootloaders/grub2/splash.png \
          --gzip-options "--force --verbose --best --rsyncable" \
          --ignore-system-defaults \
          --initramfs live-boot \
          --initramfs-compression gzip \
          --interactive false \
          --isohybrid-options "--entry 1 --offset 0 --uefi" \
          --iso-application "CodingPiratesOS Live 1.1" \
          --iso-preparer magnus@darkmagus.dk \
          --iso-publisher magnus@darkmagus.dk \
          --iso-volume "CodingPiratesOS-live-amd64" \
          --linux-flavours amd64 \
          --linux-packages "linux-image linux-headers" \
          --memtest memtest86+ \
          --parent-mirror-bootstrap https://mirror.one.com/debian/ \
          --parent-mirror-chroot-security http://security.debian.org/ \
          --mirror-bootstrap https://mirror.one.com/debian/ \
          --mirror-chroot-security http://security.debian.org/ \
          --mode debian \
          --system live \
          --archive-areas "main contrib non-free" \
          --parent-archive-areas "main contrib non-free" \
          --security true \
          --source false \
          --firmware-binary true \
          --firmware-chroot true \
          --tasksel apt \
          --updates true \
          --verbose \
          --win32-loader false

sudo lb build

#--bootappend-install config hostname=cphackos \

#--bootappend-install "priority=low nofloppy noraid noeject noefi boot=live boot_delay=0 rootdelay=0 panic=10 console=tty1 config hostname=cphackos video=vesa:ywrap,mtrr vga=788 rootfstype=ext4 components quiet silent splash DEBCONF_DEBUG=5 loglevel=7" \
#--bootappend-live "auto=true nofloppy noraid noeject noefi boot=live boot_delay=0 rootdelay=0 panic=10 console=tty1 config hostname=cphackos video=vesa:ywrap,mtrr vga=788 rootfstype=ext4 components quiet silent splash DEBCONF_DEBUG=5 loglevel=7 persistence" \
