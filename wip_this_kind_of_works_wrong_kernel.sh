qemu-system-arm -kernel /tmp/kernel* \
    -cpu arm1176 -m 256 -M versatilepb \
    -dtb ~/tmp/qemu-rpi/versatile-pb.dtb -no-reboot \
    -serial stdio  -append "root=/dev/sda1 panic=1 rootfstype=ext3 rw" \
    -drive "file=linux.img,index=0,media=disk,format=raw" \
    -net user,hostfwd=tcp::5022-:22 -net nic