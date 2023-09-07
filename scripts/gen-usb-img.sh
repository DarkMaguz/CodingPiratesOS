#!/bin/sh -e

ISO_PATH=$1
IMG_PATH=$2

USEAGE="useage:\n\t$0 PATH/TO/IMG.ISO PATH/TO/USB.IMG"
# Validate user input.
if [ ! -f $ISO_PATH ] || [ -z "$ISO_PATH" ]; then
  echo $USEAGE
  exit 1
elif [ -f $IMG_PATH ] || [ -z "$IMG_PATH" ]; then
  echo $USEAGE
  exit 1
fi

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

# Load kernel module nbd if not already loaded.
if [ -z "$(lsmod | grep nbd || true)" ]; then
  echo "Loading kernel module nbd..."
  modprobe nbd
fi

# Unmount /dev/nbd0 if mounted.
if [ ! -z "$(grep "/dev/nbd0" /proc/mounts || true)"]; then
  umount /dev/nbd0* || true
fi

# Disconnect any existing connection.
if [ -e "/dev/nbd0" ]; then
  echo "Attemt to disconnect /dev/nbd0"
  qemu-nbd --disconnect /dev/nbd0
fi

# Create a tmp file for hosting a virtual block device.
TMPIMG=$(mktemp)

# Create a qcow2 image.
qemu-img create -f qcow2 $TMPIMG 32G

# Connect qcow2 image to /dev/nbd0.
qemu-nbd --connect /dev/nbd0 -f qcow2 $TMPIMG

# Create a new MBR partition table and 2 new partitions.
fdisk /dev/nbd0 <<EOF
o
n
p
1

+10G
a
n
p
2


w
EOF

# Make iso image bootable. ???? Need this ????
# isohybrid --partok $ISO_PATH

# Write iso image to virtual disk.
dd if=$ISO_PATH of=/dev/nbd0p1 bs=4MB status=progress
sync

# Create an ext4 filesystem on the second partition.
mkfs.ext4 /dev/nbd0p2 -L persistence

# Make a tmp dir for seeding the persistence partition.
TMPDIR=$(mktemp -d)

# Mount the persistence partition.
mount /dev/nbd0p2 $TMPDIR

# Create persistence.conf file.
touch "$TMPDIR/persistence.conf"
echo "/home\n"> "$TMPDIR/persistence.conf"
sync

# Unmount all partitions on /dev/nbd0 
umount /dev/nbd0* || true

# Remove tmpdir
rmdir $TMPDIR

# Install a Master Boot Record manager.
install-mbr /dev/nbd0
sync

# Make image from virtual device.
dd if=/dev/nbd0 of=$IMG_PATH bs=4MB status=progress
sync

qemu-nbd --disconnect /dev/nbd0

rm $TMPIMG

chown 1000:1000 $IMG_PATH