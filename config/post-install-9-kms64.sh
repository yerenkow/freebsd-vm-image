#!/bin/sh

cd $mountdir

echo "nameserver 8.8.8.8" > etc/resolv.conf

cp -r ../../kms-files/ .

mkdir -p ./usr/ports

cp -r /usr/ports ./usr/

rootinstall="/root/install.sh"

chroot $mountdir $rootinstall
