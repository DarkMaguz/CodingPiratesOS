#!/bin/sh -e

qemu-system-x86_64 -m 2048 \
	-smp 2 \
	-enable-kvm \
	-cdrom $ISOPATH \
	-boot d \
	-vnc :0 \
	-device virtio-rng-pci
