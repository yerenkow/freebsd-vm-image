#!/bin/sh

rm -f $imagefile

touch $imagefile

truncate -s 4G $imagefile

mdconfig -af $imagefile -u $u

fdisk -BI /dev/md${u}
gpart create -s mbr md${u}
gpart add -t freebsd -i 1 md${u}
gpart create -s BSD md${u}s1
gpart set -a active -i 1 md${u}
gpart add -s 3536M -t freebsd-ufs -i 1 md${u}s1
gpart add -t freebsd-swap -i 2 md${u}s1

newfs -Uj /dev/md${u}s1a

mount -o rw,noatime /dev/md${u}s1a $mountdir
