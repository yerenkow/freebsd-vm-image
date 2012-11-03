#!/bin/sh


etcfs="/dev/gpt/etcfs"
varfs="/dev/gpt/varfs"

if [ -e $etcfs ]; then
    /sbin/fsck -t ffs -y $etcfs
    /sbin/mount -o rw,noatime $etcfs /etc-rw
    /sbin/mount -t unionfs /etc-rw /etc
fi

if [ -e $varfs ]; then
    /sbin/fsck -t ffs -y $varfs
    /sbin/mount -o rw,noatime $etcfs /var-rw
    /sbin/mount -t unionfs /var-rw /var
fi

