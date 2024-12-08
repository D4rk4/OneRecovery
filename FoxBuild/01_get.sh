#/bin/bash

alpineminirootfsfile="alpine-minirootfs-3.21.0-x86_64.tar.gz"
linuxver="linux-6.10.14"

wget -4 http://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/$alpineminirootfsfile
mkdir alpine-minirootfs
tar -C ./alpine-minirootfs -xf $alpineminirootfsfile
wget -4 http://cdn.kernel.org/pub/linux/kernel/v6.x/$linuxver.tar.xz
tar -xf $linuxver.tar.xz

ln -s $linuxver linux
