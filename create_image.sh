#!/bin/bash

set -e

echo -e "[Create disk image]"
dd if=/dev/zero of=/os/linux.img bs=$(expr 1024 \* 1024 \* 1024) count=1

echo -e "\n[Make partition]"
sfdisk /os/linux.img < /os/partition.txt

echo -e "\n[Format partition with ext4]"
losetup -D

LOOPDEVICE=$(losetup -f)
echo -e "\n[Using ${LOOPDEVICE} loop device]"
losetup -o $(expr 512 \* 2048) ${LOOPDEVICE} /os/linux.img
mkfs.ext4 ${LOOPDEVICE}

echo -e "\n[Copy linux directory structure to partition]"
mkdir -p /os/mnt
mount -t auto ${LOOPDEVICE} /os/mnt/
cp -R /os/linux.dir/. /os/mnt/

echo -e "\n[Setup extlinux]"
extlinux --install /os/mnt/boot/
cp /os/${DISTR}/syslinux.cfg /os/mnt/boot/syslinux.cfg
echo "  APPEND root=UUID=$(blkid -o value -s UUID | tail -2 | head -1) initrd=/initrd.img rw nosplash text biosdevname=0 net.ifnames=0 console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 consoleblank=0 systemd.show_status=true" >> /os/mnt/boot/syslinux.cfg
cat /os/mnt/boot/syslinux.cfg
echo "UUID=$(blkid -o value -s UUID | tail -2 | head -1) /dev/sda1 ext4 errors=remount-ro 0 1" >> /os/mnt/etc/fstab
# echo "LABEL=linux / ext4 defaults 0 0" >> /os/mnt/etc/fstab
# echo "BOOT_IMAGE=/vmlinuz root=LABEL=cloudimg-rootfs ro console=tty1 console=ttyS0" >> /os/mnt/proc/cmdline

echo -e "\n[Unmount]"
umount /os/mnt
losetup -D

echo -e "\n[Write syslinux MBR]"
dd if=/usr/lib/syslinux/mbr/mbr.bin of=/os/linux.img bs=440 count=1 conv=notrunc

