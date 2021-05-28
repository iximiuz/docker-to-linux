#!/usr/bin/env bash

set -xe

qemu-system-x86_64 \
    -drive file=linux.img,index=0,media=disk,format=raw \
    -m 4096 \
    -net user,id=mynet0,hostfwd=tcp::10022-:22 \
    -net nic
