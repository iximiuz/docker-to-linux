#!/bin/bash

set -e

UID_HOST=$1
GID_HOST=$2

echo_blue() {
    local font_blue="\033[94m"
    local font_bold="\033[1m"
    local font_end="\033[0m"

    echo -e "\n${font_blue}${font_bold}${1}${font_end}"
}

echo_blue "[Create disk image]"
dd if=/dev/zero of=/os/${DISTR}.img bs=$(expr 1024 \* 1024 \* 1024) count=1

echo_blue "[Make partition]"
sfdisk /os/${DISTR}.img < /os/partition.txt

echo_blue "\n[Format partition with ext4]"
losetup -D
LOOPDEVICE=$(losetup -f)
echo -e "\n[Using ${LOOPDEVICE} loop device]"
losetup -o $(expr 512 \* 2048) ${LOOPDEVICE} /os/${DISTR}.img
mkfs.ext4 ${LOOPDEVICE}

echo_blue "[Copy ${DISTR} directory structure to partition]"
mkdir -p /os/mnt
mount -t auto ${LOOPDEVICE} /os/mnt/
cp -a /os/${DISTR}.dir/. /os/mnt/

echo_blue "[Setup extlinux]"
extlinux --install /os/mnt/boot/
cp /os/${DISTR}/syslinux.cfg /os/mnt/boot/syslinux.cfg
rm /os/mnt/.dockerenv

echo_blue "[Unmount]"
umount /os/mnt
losetup -D

echo_blue "[Write syslinux MBR]"
dd if=/usr/lib/syslinux/mbr/mbr.bin of=/os/${DISTR}.img bs=440 count=1 conv=notrunc

echo_blue "[Convert to qcow2]"
qemu-img convert -c /os/${DISTR}.img -O qcow2 /os/${DISTR}.qcow2

[ "${UID_HOST}" -a "${GID_HOST}" ] && chown ${UID_HOST}:${GID_HOST} /os/${DISTR}.img /os/${DISTR}.qcow2

rm -r /os/${DISTR}.dir