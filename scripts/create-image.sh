#!/bin/sh

rm -f $imagefile

touch $imagefile

truncate -s 4G $imagefile

mdconfig -af $imagefile -u $u

gpart create -s gpt /dev/md$u

gpart add -s 64k -t freebsd-boot -i 1 md$u

gpart add -t freebsd-ufs -s 2G -i 2 md$u

gpart add -t freebsd-swap -i 3 md$u

newfs -Uj /dev/md${u}p2

mount -o rw,noatime /dev/md${u}p2 $mountdir
