# docker-to-linux - make bootable linux disk image abusing docker

There is no real goal behind this project. Just out of my curiosity what if:

  - one launches Docker image (debian, alpine, etc)
  - installs linux kernel & init system (systemd, OpenRC, etc)
  - dumps container's directory structure to some disk image
  - installs bootloader (syslinux) to this image...

Then it should be probably possible to launch a ~~real~~ virtual machine with such a disk image!

Try it out:

```bash
make debian
qemu-system-x86_64 -drive file=linux.img,index=0,media=disk,format=raw
make clean

make alpine
qemu-system-x86_64 -drive file=linux.img,index=0,media=disk,format=raw
make clean
```

It works!

Check `Makefile` content for implementation details.

