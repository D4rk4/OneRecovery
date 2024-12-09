#!/bin/bash
cat > alpine-minirootfs/etc/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.4.4
EOF
cat > alpine-minirootfs/mk.sh << EOF
echo onerecovery > /etc/hostname && hostname -F /etc/hostname
echo 127.0.1.1 onerecovery onerecovery >> /etc/hosts
apk update
apk upgrade
apk add openrc nano mc bash parted dropbear dropbear-ssh efibootmgr \
    lvm2 cryptsetup e2fsprogs e2fsprogs-extra dosfstools \
    dmraid mdadm fuse gawk grep sed util-linux wget curl rsync \
    unzip tar zstd agetty debootstrap zfs 
    # libc6-compat syslinux htop gpg eudev util-linux pciutils usbutils coreutils
rm /var/cache/apk/*
exit
EOF
chmod +x alpine-minirootfs/mk.sh
chroot alpine-minirootfs /bin/ash /mk.sh
rm alpine-minirootfs/mk.sh