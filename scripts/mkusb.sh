#!/bin/sh

ISO_PATH=$1
USB_DEV=$2

USEAGE="useage:\n\t$0 PATH/TO/IMG.ISO /dev/sdX"
# Validate user input.
if [ ! -f $ISO_PATH ] || [ -z "$ISO_PATH" ]; then
  echo $USEAGE
  exit 1
elif [ ! -b $USB_DEV ] || [ -z "$USB_DEV" ]; then
  echo $USEAGE
  exit 1
fi

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

# Unmount all partitions of the usb device.
umount "$USB_DEV"* &>/dev/null || true

dd if=/dev/null of=$USB_DEV bs=512 count=1 status=progress
sync

# Create a new MBR partition table and 2 new partitions.
fdisk $USB_DEV <<EOF
o
n
p
1

+12G
a
n
p
2


w
EOF

# Make iso image bootable. ???? Need this ????
#isohybrid --partok $ISO_PATH

# Write iso image to the first partition.
dd if=$ISO_PATH of="$USB_DEV"1 bs=4MB status=progress
sync

# Create an ext4 filesystem on the second partition.
mkfs.ext4 "$USB_DEV"2 -L persistence

# Make a tmp dir for seeding the persistence partition.
TMPDIR=$(mktemp -d)

# Mount the persistence partition.
mount "$USB_DEV"2 $TMPDIR

# Create persistence.conf file.
touch "$TMPDIR/persistence.conf"
echo "/home\n"> "$TMPDIR/persistence.conf"
sync

# Unmount all partitions of the usb device.
umount "$USB_DEV"* &>/dev/null || true

# Install a Master Boot Record manager.
install-mbr $USB_DEV
isohybrid --partok "$USB_DEV"1
sync

# Remove tmpdir
rmdir $TMPDIR