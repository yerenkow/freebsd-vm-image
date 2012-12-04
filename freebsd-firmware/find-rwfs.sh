#!/bin/sh


etcfs="/dev/gpt/etcfs"
varfs="/dev/gpt/varfs"
localfs="/dev/gpt/localfs"

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

if [ -e $localfs ]; then
    /sbin/fsck -t ffs -y $localfs
    /sbin/mount -o rw,noatime $localfs /usr/local
    if [ -e /usr/local/tmp ]; then
	/sbin/mount -t unionfs /usr/local/tmp /tmp
    fi
    if [ -e /usr/local/root-rw ]; then
	/sbin/mount -t unionfs /usr/local/root-rw /root
    fi
fi

