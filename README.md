# docker-to-linux - make bootable linux disk image abusing docker

There is no real goal behind this project. Just out of my curiosity what if:

  - launch a base Linux container (debian, alpine, etc)
  - pull in Linux kernel & init system (systemd, OpenRC, etc)
  - dump container's filesystem to a disk image
  - install bootloader (syslinux) to this image...

Then it should be probably possible to launch a ~~real~~ virtual machine with such an image!

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

Check out `Makefile` for more details or read my article on <a href="https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/">iximiuz.com</a>.
