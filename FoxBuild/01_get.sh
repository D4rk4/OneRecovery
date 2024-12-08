#/bin/bash

alpineminirootfsfile="alpine-minirootfs-3.21.0-x86_64.tar.gz"
linuxver="linux-6.10.14"
zfsver="2.3.0-rc3"

# Getting the Alpine minirootfs
wget -c4 http://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/$alpineminirootfsfile
mkdir alpine-minirootfs
tar -C ./alpine-minirootfs -xf $alpineminirootfsfile

# Getting the Linux kernel
wget -c4 http://cdn.kernel.org/pub/linux/kernel/v6.x/$linuxver.tar.xz
tar -xf $linuxver.tar.xz
ln -s $linuxver linux

# Getting the OpenZFS source
wget -c4 https://github.com/openzfs/zfs/releases/download/zfs-${zfsver}/zfs-${zfsver}.tar.gz
tar -xf zfs-${zfsver}.tar.gz && mv zfs-${zfsver} zfs

