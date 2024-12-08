#/bin/bash

ln -fs /etc/init.d/mdev ./alpine-minirootfs/etc/runlevels/sysinit/mdev
ln -fs /etc/init.d/devfs ./alpine-minirootfs/etc/runlevels/sysinit/devfs
ln -fs /etc/init.d/dmesg ./alpine-minirootfs/etc/runlevels/sysinit/dmesg
ln -fs /etc/init.d/syslog ./alpine-minirootfs/etc/runlevels/sysinit/syslog
ln -fs /etc/init.d/hwdrivers ./alpine-minirootfs/etc/runlevels/sysinit/hwdrivers
ln -fs /etc/init.d/networking ./alpine-minirootfs/etc/runlevels/sysinit/networking

ln -fs /sbin/agetty ./alpine-minirootfs/sbin/getty 

cat ./zfiles/interfaces > ./alpine-minirootfs/etc/network/interfaces
cat ./zfiles/resolv.conf > ./alpine-minirootfs/etc/resolv.conf
cat ./zfiles/profile > ./alpine-minirootfs/etc/profile
cat ./zfiles/shadow > ./alpine-minirootfs/etc/shadow
cat ./zfiles/init > ./alpine-minirootfs/init
chmod +x ./alpine-minirootfs/init

# Enamble serial console
sed -i 's/^#ttyS0/ttyS0/' ./alpine-minirootfs/etc/inittab

# Enable root login on all local consoles
sed -i 's|\(/sbin/getty \)|\1 -a root |' ./alpine-minirootfs/etc/inittab

#mv ./alpine-minirootfs/etc/profile.d/color_prompt ./alpine-minirootfs/etc/profile.d/color_prompt.sh
#mv ./alpine-minirootfs/etc/profile.d/locale ./alpine-minirootfs/etc/profile.d/locale.sh
#chmod +x ./alpine-minirootfs/etc/profile.d/*.sh
#mkdir ./alpine-minirootfs/media/ubuntu
#cat > ./alpine-minirootfs/etc/fstab << EOF
#/dev/cdrom	/media/cdrom	iso9660	noauto,ro 0 0
#/dev/usbdisk	/media/usb	vfat	noauto,ro 0 0
#/dev/sda5	/media/ubuntu	ext4	rw,relatime 0 0
#EOF

mkdir -p alpine-minirootfs/lib/
cp zfiles/.config linux/

#cd linux
#make menuconfig
