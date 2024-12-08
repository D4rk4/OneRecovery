#!/bin/bash

set -e

# RootFS variables
ROOTFS="alpine-minirootfs"
CACHEPATH="$ROOTFS/var/cache/apk/"
SHELLHISTORY="$ROOTFS/root/.ash_history"
DEVCONSOLE="$ROOTFS/dev/console"
MODULESPATH="$ROOTFS/lib/modules/"
DEVURANDOM="$ROOTFS/dev/urandom"

# Kernel variables
KERNELVERSION="$(ls -d linux-* | awk '{print $1}' | head -1 | cut -d- -f2)"
KERNELPATH="linux"
export INSTALL_MOD_PATH="../$ROOTFS/"

# Build threads equall CPU cores
THREADS=$(getconf _NPROCESSORS_ONLN)

echo "      ____________  "
echo "    /|------------| "
echo "   /_|  .---.     | "
echo "  |    /     \    | "
echo "  |    \.6-6./    | "
echo "  |    /\`\_/\`\    | "
echo "  |   //  _  \\\   | "
echo "  |  | \     / |  | "
echo "  | /\`\_\`>  <_/\`\ | "
echo "  | \__/'---'\__/ | "
echo "  |_______________| "
echo "                    "
echo "   OneRecovery.efi  "

##########################
# Checking root filesystem
##########################

echo "----------------------------------------------------"
echo -e "Checking root filesystem\n"

# Clearing apk cache 
if [ "$(ls -A $CACHEPATH)" ]; then 
    echo -e "Apk cache folder is not empty: $CACHEPATH \nRemoving cache...\n"
    rm $CACHEPATH*
fi

# Remove shell history
if [ -f $SHELLHISTORY ]; then
    echo -e "Shell history found: $SHELLHISTORY \nRemoving history file...\n"
    rm $SHELLHISTORY
fi

# Clearing kernel modules folder 
if [ "$(ls -A $MODULESPATH)" ]; then 
    echo -e "Kernel modules folder is not empty: $MODULESPATH \nRemoving modules...\n"
    rm -r $MODULESPATH*
fi

# Removing dev bindings
if [ -e $DEVURANDOM ]; then
    echo -e "/dev/ bindings found: $DEVURANDOM. Unmounting...\n"
    umount $DEVURANDOM || echo -e "Not mounted. \n"
    rm $DEVURANDOM
fi


## Check if console character file exist
#if [ ! -e $DEVCONSOLE ]; then
#    echo -e "ERROR: Console device does not exist: $DEVCONSOLE \nPlease create device file:  mknod -m 600 $DEVCONSOLE c 5 1"
#    exit 1
#else
#    if [ -d $DEVCONSOLE ]; then # Check that console device is not a folder 
#        echo -e  "ERROR: Console device is a folder: $DEVCONSOLE \nPlease create device file:  mknod -m 600 $DEVCONSOLE c 5 1"
#        exit 1
#    fi
#
#    if [ -f $DEVCONSOLE ]; then # Check that console device is not a regular file
#        echo -e "ERROR: Console device is a regular: $DEVCONSOLE \nPlease create device file:  mknod -m 600 $DEVCONSOLE c 5 1"
#    fi
#fi

# Print rootfs uncompressed size
echo -e "Uncompressed root filesystem size WITHOUT kernel modules: $(du -sh $ROOTFS | cut -f1)\n"


cd $KERNELPATH 

##########################
# Bulding kernel
##########################
echo "----------------------------------------------------"
echo -e "Building kernel with initrams using $THREADS threads...\n"
nice -19 make -s -j$THREADS

##########################
# Bulding kernel modules
##########################

#echo "----------------------------------------------------"
echo -e "Building kernel mobules using $THREADS threads...\n"
nice -19 make -s modules -j$THREADS

# Copying kernel modules in root filesystem
echo "----------------------------------------------------"
echo -e "Copying kernel modules in root filesystem\n"
nice -19 make -s modules_install

# Building and installing ZFS modules
echo "----------------------------------------------------"
echo "Building and installing ZFS modules"
cd ../zfs
./autogen.sh
./configure --with-linux=$(pwd)/../$KERNELPATH --with-linux-obj=$(pwd)/../$KERNELPATH
nice -19 make -s -j$THREADS
DESTDIR=$(realpath $(pwd)/../$ROOTFS)
make DESTDIR=${DESTDIR} INSTALL_MOD_PATH=${DESTDIR} install
echo -e "Uncompressed root filesystem size WITH kernel modules: $(du -sh $DESTDIR | cut -f1)\n"
cd $(pwd)/../$KERNELPATH


# Creating modules.dep
echo "----------------------------------------------------"
echo -e "Copying modules.dep\n"
nice -19 depmod -b ../$ROOTFS -F System.map $KERNELVERSION

##########################
# Bulding kernel
##########################
echo "----------------------------------------------------"
echo -e "Building kernel with initrams using $THREADS threads...\n"
nice -19 make -s -j$THREADS


##########################
# Get builded file
##########################

#rm /boot/efi/EFI/OneFileLinux.efi
#cp arch/x86/boot/bzImage /boot/efi/EFI/OneFileLinux.efi
sync
cp arch/x86/boot/bzImage ../OneRecovery.efi
sync
#cd ..
echo "----------------------------------------------------"
echo -e "\nBuilded successfully: $(pwd)/../OneRecovery.efi\n"
# WA for ZFS sync (:
sleep 3 && sync
echo -e "File size: $(du -sh $(pwd)/../OneRecovery.efi | cut -f1)\n"
