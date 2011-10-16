#!/bin/sh

#yep, it's not safe. todo fix
cp $mountdir/boot/boot0 /tmp/boot0

umount $mountdir

#gpart bootcode -b /tmp/boot0 md$u

mdconfig -du $u
