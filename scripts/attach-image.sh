#!/bin/sh

mdconfig -af $imagefile -u $u

mount -o rw,noatime /dev/md${u}s1 $mountdir
