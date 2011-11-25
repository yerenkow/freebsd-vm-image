#!/bin/sh

sync && sleep 30
umount $mountdir

#just in case;
sync && sleep 30
umount $mountdir

mdconfig -du $u
