export RPI_KERNEL=kernel-qemu-4.14.79-stretch
export RPI_FS=2019-09-26-raspbian-buster-lite.img
export PTB_FILE=versatile-pb.dtb
export IMAGE_FILE=2019-09-26-raspbian-buster-lite.zip
export IMAGE=http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/$IMAGE_FILE
export GIT_REPO=https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master

cd /tmp

if [ ! -f $IMAGE_FILE ] ; then
    echo ====== Downloading image
    wget $IMAGE
    unzip $IMAGE_FILE
fi

if [ ! -f $RPI_KERNEL ] ; then
    echo ====== Downloading kernel
    wget "$GIT_REPO/$RPI_KERNEL"
fi

if [ ! -f $PTB_FILE ] ; then
    echo ====== Downloading PTB file
    wget "$GIT_REPO/$PTB_FILE"
fi

qemu-system-arm -kernel /tmp/$RPI_KERNEL \
    -cpu arm1176 -m 256 -M versatilepb \
    -dtb $PTB_FILE -no-reboot \
    -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
    -drive "file=$RPI_FS,index=0,media=disk,format=raw" \
    -net user,hostfwd=tcp::5022-:22 -net nic