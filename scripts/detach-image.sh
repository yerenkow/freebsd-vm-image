#!/bin/sh

sync && sleep 30
umount $mountdir

#just in case;
sync && sleep 30
umount $mountdir

#gpart bootcode -b /tmp/boot0 md$u

mdconfig -du $u
