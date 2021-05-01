# docker-to-linux - make bootable Linux disk image abusing Docker

**UPD:** _Two years after creating this project I clearly can see some interest in building VM images from containers and/or Dockerfiles. **If you’re aware of the real use of the docker-to-linux project, [please drop me a message and share your experience](https://twitter.com/iximiuz)**. It may help me to develop a second generation of this tool covering real-world scenarios with a more user-friendly UX. Thanks!_

There is no real goal behind this project. Just out of my curiosity what if:

  - launch a base Linux container (debian, alpine, etc)
  - pull in Linux kernel & init system (systemd, OpenRC, etc)
  - dump container's filesystem to a disk image
  - install bootloader (syslinux) to this image...

Then it should be probably possible to launch a ~~real~~ virtual machine with such an image!

Try it out:

```bash
sudo make debian
qemu-system-x86_64 -drive file=linux.img,index=0,media=disk,format=raw
sudo make clean

sudo make alpine
qemu-system-x86_64 -drive file=linux.img,index=0,media=disk,format=raw
sudo make clean
```

It works!

Check out `Makefile` for more details or read my article on <a href="https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/">iximiuz.com</a>.
