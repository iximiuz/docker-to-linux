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
# 1. Build the image.
#    Depending on your setup, you may need to preceed `make` with `sudo`.
make debian  # or ubuntu, or alpine

# 2. Run it! Use username `root` and password `root` to log in.
qemu-system-x86_64 -drive file=linux.img,index=0,media=disk,format=raw -m 4096

# 3. Clean up when you are done.
make clean
```

It works!

Check out `Makefile` for more details or read my article on <a href="https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/">iximiuz.com</a>.

## Features
- Real quick build a bootable Linux image with a single command!
- 3 target distributives: Ubuntu 20.04, Debian Bullseye, Alpine 3.13.5
- Build from macOS (including M1 chips) or Linux hosts

## FAQ
- Q: I'm getting an error about "read-only filesystem". How can I make it writable?

  A: It's Linux default behaviour to mount the / filesystem as read-only. You can always remount it with `mount -o remount,rw /`.

- Q: How can I access network from the VM / How can I SSH into the VM?

  A: Networking is in early stages at the moment. If you want to configure it yourself, search for TUN/TAP/bridge devices.


## Network / basic connectivity

You'll need a virtual device (tun/tap) bridged with an interface such as ethernet or docker0.

Follow these steps if you already have docker0:

Create tap interface

    tunctl -t tap0 -u `whoami`

Add tap0 to bridge

    brctl addif docker0 tap0
    ip link set ens3

Once you've done this you'll need to configure the interface inside the VM. Asumming your network interface is ens3.

    ip addr add 172.17.0.10/16 dev ens3
    ip link set ens3 up
    ip route add default via 172.17.0.1

## Release notes
#### 2021-05-07
- Fix - Ubuntu 20.04 stopped working because of the changed path to vmlinuz and initrd files.

#### 2021-05-02
- Fix macOS support [#10](https://github.com/iximiuz/docker-to-linux/issues/10) (thanks to @xavigonzalvo for reporting and suggesting the fix)
  - move `losetup` call from Makefile to the builder container
  - explicitly select amd64 architecture in target distr Dockerfiles to support builds on ARM hosts (_aka_ M1)
- Upgrade target distr versions
  - Ubuntu 18.04 -> 20.04
  - Debian Stretch -> Bullseye
  - Alpine 3.9.4 -> 3.13.5

#### 2020-02-29
- Improve Alpine support [#7](https://github.com/iximiuz/docker-to-linux/pull/7) (creds @monperrus)

#### 2019-08-02
- Fix loopback device lookup [#3](https://github.com/iximiuz/docker-to-linux/pull/3) (creds @christau)

#### 2019-06-03
- Initial release

## TODO
- add basic networking support
- make filesystem writable after boot
- support different image formats (e.g. VirtualBox VDI)
- support different target architectures (e.g. ARM)

